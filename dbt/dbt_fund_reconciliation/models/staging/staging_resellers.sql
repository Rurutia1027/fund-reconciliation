WITH resellers AS (
    SELECT reseller_id, reseller_name, comission_pct, 
    ROW_NUMBER() OVER (PARTITION BY reseller_id ORDER BY loaded_timestamp DESC) as rn  
    FROM {{ref('src_resellers')}}
) 

SELECT reseller_id, reseller_name, commission_pct
FROM resellers 
WHERE rn = 1