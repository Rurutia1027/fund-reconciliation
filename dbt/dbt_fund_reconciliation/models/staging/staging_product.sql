WITH products AS (
    SELECT product_id, product_name, g.id AS geograph_key, product_price,  
    row_number() over (PARTITION BY product_id order by e.loaded_timestamp DESC) AS rn
    FROM {{ref('src_products')}} e 
    JOIN {{ref('gengraphy')}} g on g.cityname = e.product_city 
)

SELECT product_id, product_name, geography_key, product_price:numeric AS product_price
FROM products 
WHERE rn = 1 