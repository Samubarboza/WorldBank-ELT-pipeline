INSERT INTO stg.stg_countries (
    country_code,
    country_name,
    region,
    income_level,
    execution_date
)
SELECT
    country->>'id',
    country->>'name',
    country->'region'->>'value',
    country->'incomeLevel'->>'value',
    r.execution_date
FROM raw.raw_countries r,
LATERAL jsonb_array_elements(r.payload->1) AS country;
