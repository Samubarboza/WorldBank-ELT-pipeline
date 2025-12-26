-- cargamos la dimensión de fechas usando los años presentes en STAGING

INSERT INTO mart.dim_date (year)
SELECT DISTINCT
    year
FROM stg.stg_indicator_values
ON CONFLICT (year) DO NOTHING;
