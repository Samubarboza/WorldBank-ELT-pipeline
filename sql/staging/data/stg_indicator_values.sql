INSERT INTO stg.stg_indicator_values (
    indicator_code,
    country_code,
    year,
    value,
    execution_date
)
SELECT DISTINCT
    item->'indicator'->>'id'  AS indicator_code,
    item->>'countryiso3code'  AS country_code,
    (item->>'date')::INT      AS year,
    (item->>'value')::NUMERIC AS value,
    r.execution_date
FROM raw.raw_indicator_values r
CROSS JOIN LATERAL jsonb_array_elements(r.payload->0->1) AS item
WHERE item->>'value' IS NOT NULL
    AND item->>'date' IS NOT NULL
    AND item->'indicator'->>'id' IS NOT NULL
    AND item->'country'->>'id' IS NOT NULL
ON CONFLICT (
    indicator_code,
    country_code,
    year,
    execution_date
) DO NOTHING;
