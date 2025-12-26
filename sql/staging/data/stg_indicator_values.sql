INSERT INTO stg.stg_indicator_values (
    indicator_id,
    indicator_name,
    country_code,
    country_name,
    year,
    value,
    execution_date
)
SELECT
    item->'indicator'->>'id'        AS indicator_id,
    item->'indicator'->>'value'     AS indicator_name,
    item->'country'->>'id'          AS country_code,
    c.country_name                  AS country_name,
    (item->>'date')::INT            AS year,
    (item->>'value')::NUMERIC       AS value,
    r.execution_date
FROM raw.raw_indicator_values r,
    LATERAL jsonb_array_elements(r.payload) AS page,
    LATERAL jsonb_array_elements(page->1) AS item
JOIN stg.stg_countries c
    ON item->'country'->>'id' = c.country_code
WHERE item->>'value' IS NOT NULL;
