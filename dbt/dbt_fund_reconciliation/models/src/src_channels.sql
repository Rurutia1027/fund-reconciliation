WITH raw_channels AS (
    SELECT * FROM {{source('import', 'channels')}}
)

SELECT channel_id, channel_name, loaded_timestamp 
FROM raw_channels 