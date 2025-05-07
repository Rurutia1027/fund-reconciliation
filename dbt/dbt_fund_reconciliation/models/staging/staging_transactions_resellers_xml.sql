{{
    config (
        MATERIALIZED='incremental'
    )
}}

WITH 
{% if is_incremental() %}
latest_transaction AS (
    SELECT MAX(loaded_timestamp) AS MAX_TRANSACTION FROM {{ this }}
)
{% endif %}

TRANS_XML AS (
    SELECT 
        {{ dbt_utils.surrogate_key(
            ['reseller_id', 'transction_id']
        ) }} AS customer_key, 
        reseller_id, 
        transaction_id, 
        product_name, 
        total_amount, 
        no_purchased_postcards, 
        date_bought, 
        sales_channel,
        office_location, 
        loaded_timestamp
    FROM 
        {{ source(
            'preprocessed',
            'resellerxmlextracted'
        ) }}


{% if is_incremental() %}
-- this filter will only be applied on an incremental run 
WHERE loaded_timestamp > (SELECT max_transaction FROM latest_transaction LIMIT 1)
{% endif %}

)

SELECT 
  t.customer_key,
  transaction_id,
  e.product_key, 
  c.channel_key,
  t.reseller_id, 
  to_char(
    date_bought,
    'YYYYMMDD'
  )::INT AS bought_date_key,
  total_amount::numeric, 
  no_purchased_postcards, 
  e.product_price::numeric,
  e.geography_key,
  s.commission_pct * total_amount::numeric AS commisionpaid, 
  s.commission_pct, 
  loaded_timestamp
FROM 
  trans_xml t 
  JOIN {{ ref('dim_product' ) }} e 
  ON t.product_name = e.product_name 
  JOIN {{ ref('dim_channel')}} c
  ON t.sales_channel = c.channel_name 
  JOIN {{ ref('dim_customer')}} cu 
  ON t.customer_key = cu.customer_key 
  JOIN {{ ref('dim_salesagent')}} s
  ON t.reseller_id = s.original_reseller_id 