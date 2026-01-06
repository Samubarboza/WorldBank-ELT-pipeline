INSERT INTO mart.fact_indicator_values (
    country_id,
    indicator_id,
    date_id,
    year,
    value,
    execution_date
)
SELECT
    c.country_id,
    i.indicator_id,
    d.date_id,
    s.year,
    s.value,
    s.execution_date
FROM stg.stg_indicator_values s
JOIN mart.dim_country c
    ON s.country_code = c.country_code
JOIN mart.dim_indicator i
    ON s.indicator_code = i.indicator_code
JOIN mart.dim_date d
    ON s.year = d.year
WHERE s.year BETWEEN 1960 AND EXTRACT(YEAR FROM CURRENT_DATE)
    AND s.value IS NOT NULL
ON CONFLICT (country_id, indicator_id, year, execution_date) DO NOTHING;
