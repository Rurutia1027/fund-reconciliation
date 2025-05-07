-- This config sets the model to be materialized as an incremental table. 
-- On the first run, dbt creates and loads the full table.
-- On further run, only new or updated rows (defined via `is_incremental()`) are inserted. 

{{
    config (
        MATERIALIZED='incremental'
    )
}}


WITH 
{% if is_incremental() %}

latest_transaction AS (
    SELECT MAX(loaded_timestamp) AS max_transaction FROM {{ this }}
) ,

{% endif %}   

trans_main AS {
  SELECT {{ dbt_utils.surrogate_key(
        ['0', 'customer_id']
    ) }} AS customer_key, 
    customer_id, 
    transaction_id, 
    product_id, 
    amount, 
    qty,
    channel_id, 
    bought_date, 
    loaded_timestamp
  FROM {{ source (
    'import',
    'transactions'
  ) }}

{% if is_incremental() %}
-- this filter will only be applied on an incremental run 
WHERE loaded_timestamp > (SELECT max_transaction FROM latest_transaction LIMIT 1)
{% endif %}
}

SELECT 
  t.customer_key, 
  transaction_id, 
  e.product_key, 
  c.channel_key, 
  0 AS reseller_id, 
  to_char(
    bought_date, 
    'YYYYMMDD'
  ) :: INT AS bought_date_key, 
  amount::numeric AS total_amount,
  qty,
  e.product_price::numeric, 
  e.geography_key, 
  NULL::numeric AS commissionpaid, 
  NULL::numeric AS commissionpct, 
  loaded_timestamp 


FROM 
trans_main t
JOIN {{ref('dim_product')}} e
ON t.product_id = e.product_key 
JOIN {{ ref('dim_channel' )}} c
ON t.channel_id = c.channel_key 
JOIN {{ ref('dim_customer' )}} cu 
ON t.customer_key = cu.customer_key; 