-- cargamos la dimensión de indicadores usando datos desde STAGING

INSERT INTO mart.dim_indicator (indicator_code)
SELECT DISTINCT
    indicator_id
FROM stg.stg_indicator_values
ON CONFLICT (indicator_code) DO NOTHING;
