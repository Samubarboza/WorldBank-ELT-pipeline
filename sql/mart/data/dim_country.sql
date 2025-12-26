-- cargamos la dimensión país usando datos limpios desde STAGING

INSERT INTO mart.dim_country (
    country_code,
    country_name,
    region,
    income_level
)
SELECT DISTINCT
    country_code,
    country_name,
    region,
    income_level
FROM stg.stg_countries
ON CONFLICT (country_code) DO NOTHING;
