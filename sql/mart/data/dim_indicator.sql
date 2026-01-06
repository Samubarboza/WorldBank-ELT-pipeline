INSERT INTO mart.dim_indicator (
    indicator_code
)
SELECT DISTINCT
    indicator_code
FROM stg.stg_indicator_values
WHERE indicator_code IS NOT NULL
ON CONFLICT (indicator_code) DO NOTHING;
