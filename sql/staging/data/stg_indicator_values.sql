INSERT INTO stg.stg_indicator_values (
    indicator_code,
    country_code,
    year,
    value,
    execution_date
)
SELECT DISTINCT
    item->'indicator'->>'id'      AS indicator_code,
    item->>'countryiso3code'      AS country_code,
    (item->>'date')::INT          AS year,
    (item->>'value')::NUMERIC     AS value,
    r.execution_date
FROM raw.raw_indicator_values r
-- 1) iteramos todas las páginas
CROSS JOIN LATERAL jsonb_array_elements(r.payload) AS page
-- 2) iteramos los datos dentro de cada página
CROSS JOIN LATERAL jsonb_array_elements(page->1) AS item
WHERE item->>'value' IS NOT NULL
    AND item->>'date' IS NOT NULL
    AND item->'indicator'->>'id' IS NOT NULL
    AND item->>'countryiso3code' IS NOT NULL
ON CONFLICT (
    indicator_code,
    country_code,
    year,
    execution_date
) DO NOTHING;
