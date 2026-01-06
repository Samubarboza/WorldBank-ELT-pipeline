SELECT
    country_id,
    country_code,
    country_name,
    region,
    income_level
FROM mart.dim_country
WHERE country_code IS NOT NULL
ORDER BY country_name;
