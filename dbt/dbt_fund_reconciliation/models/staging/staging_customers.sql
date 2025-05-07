WITH 
customers_main AS (
    SELECT customer_id, first_name, last_name, email
    FROM {{ref('src_customers')}}
), 

customers_csv AS (
    SELECT 
    
    customer_first_name, 
    customer_last_name,
    customer_email,
    split_part(split_part(import_file, '_', 3), '.', 1)::int AS reseller_id, 
    transaction_id  

    -- `ref()` is used to reference another dbt model defined in current project (e.g., models/src/...).
    -- It ensures proper dependency tracking and build order.
    FROM {{ref('src_resellerscsv')}}
), 

customers_xml AS (
    SELECT 

    -- `source()` is used to reference external tables that exist in the databases or other sources declared in sources.yml & profiels.yml files as external datasources reference signals.
    -- These must be declared in a sources.yml fiel and resolved via the profile configuration.
    FROM {{source('preprocessed', 'resellerxmlextracted')}}
), 

customers AS (
    SELECT reseller_id, transaction_id AS customer_id, customer_first_name, customer_last_name, customer_email
    FROM customers_csv 

    UNION  

    SELECT reseller_id, transaction_id AS customer_id, customer_first_name, customer_last_name, customer_email
    FROM customers_xml 

    UNION

    SELECT 0 AS reseller_id, customer_id, first_name, last_name, email FROM customers_main 
)


-- This query creates a unique surrogate key (customer_key) by hashing together
-- the reseller_id and customer_id fields from the `customers` table.
-- It then performs a LEFT JOIN with the `dim_salesagent` dimension table
-- on reseller_id to enrich each customer record with its associated sales agent.

SELECT {{ dbt_utils.surrogate_key([
    'c.reseller_id',
    'customer_id']
    )}} as customer_id, 

customer_first_name, 
customer_last_name, 
customer_email, 
s.sales_agent_key

FROM customers c 
LEFT JOIN {{ref('dim_salesagent')}} s 
ON c.reseller_id = s.original_reseller_id 