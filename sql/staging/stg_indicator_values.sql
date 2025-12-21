-- transformamos los valores de indicadores desde RAW y los guardamos estructurados en STAGING
CREATE TABLE IF NOT EXISTS stg.stg_indicator_values AS
SELECT
    item->'country'->>'id'        AS country_code,
    item->'indicator'->>'id'      AS indicator_code,
    (item->>'date')::INT          AS year,
    (item->>'value')::FLOAT       AS value,
    r.execution_date
FROM raw.raw_indicator_values r,
LATERAL jsonb_array_elements(r.payload) AS page,
LATERAL jsonb_array_elements(page->1) AS item
-- Aca hago el MAPE0 ISO2 -> ISO3
JOIN stg.stg_countries c
    ON item->'country'->>'value' = c.country_name
WHERE item->>'value' IS NOT NULL;

--Toma los valores de indicadores desde RAW, desarma el JSON, convierte el código de país de ISO2 a ISO3 usando la tabla de países y guarda los datos listos para el Data Mart.