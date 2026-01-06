INSERT INTO mart.dim_country (
    country_code,
    country_name,
    region,
    income_level
)
SELECT DISTINCT ON (country_code)
    country_code,
    country_name,
    region,
    income_level
FROM stg.stg_countries
WHERE country_code IS NOT NULL
ORDER BY country_code, execution_date DESC
ON CONFLICT (country_code) DO NOTHING;
