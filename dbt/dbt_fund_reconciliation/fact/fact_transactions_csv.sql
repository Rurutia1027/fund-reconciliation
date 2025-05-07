{{ config(materialized='incremental') }}

WITH latest_transaction AS (
  {% if is_incremental() %}
  SELECT MAX(loaded_timestamp) AS max_transaction FROM {{ this }}
  {% endif %}
),
resellers_csv AS (
  SELECT
    SPLIT_PART(SPLIT_PART(imported_file, '.', -2), '_', -1)::INT AS reseller_id,
    transaction_id,
    product_name,
    total_amount,
    number_of_purchased_postcards,
    created_date,
    office_location,
    sales_channel,
    loaded_timestamp
  FROM {{ source('import', 'resellercsv') }}
  {% if is_incremental() %}
  WHERE loaded_timestamp > (SELECT max_transaction FROM latest_transaction)
  {% endif %}
)
SELECT
  {{ dbt_utils.surrogate_key(['reseller_id', 'transaction_id']) }} AS transaction_key,
  reseller_id,
  transaction_id,
  product_name,
  total_amount,
  number_of_purchased_postcards,
  created_date,
  office_location,
  sales_channel,
  loaded_timestamp
FROM resellers_csv