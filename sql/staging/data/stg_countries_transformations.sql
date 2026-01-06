INSERT INTO stg.stg_countries (
    country_code,
    country_name,
    region,
    income_level,
    execution_date
)
SELECT DISTINCT
    country->>'id'                      AS country_code,
    country->>'name'                    AS country_name,
    country->'region'->>'value'         AS region,
    country->'incomeLevel'->>'value'    AS income_level,
    r.execution_date
FROM raw.raw_countries r
CROSS JOIN LATERAL jsonb_array_elements(r.payload->1) AS country
WHERE country->>'id' IS NOT NULL
ON CONFLICT (country_code, execution_date) DO NOTHING;
