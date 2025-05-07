{{
    config(
        MATERIALIZED='table',
        UNIQUE_KEY='product_key'
    )
}}

SELECT product_id AS product_key, product_id AS original_product_id, product_name, geography_key, product_price 
FROM {{ref('staging_product')}}