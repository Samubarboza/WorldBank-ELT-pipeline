-- agarramos los datos países desde RAW, desarmamos el JSON y los guardamos estructurados en STAGING
CREATE TABLE IF NOT EXISTS stg.stg_countries AS
SELECT
    country->>'id'            AS country_code,
    country->>'name'          AS country_name,
    country->'region'->>'value'       AS region,
    country->'incomeLevel'->>'value'  AS income_level,
    r.execution_date
FROM raw.raw_countries r,
LATERAL jsonb_array_elements(r.payload->1) AS country;
