SELECT
    c.country_code,
    c.country_name,
    c.region,
    c.income_level,
    i.indicator_code,
    d.year,
    f.value,
    f.execution_date
FROM mart.fact_indicator_values f
LEFT JOIN mart.dim_country c
    ON f.country_id = c.country_id
LEFT JOIN mart.dim_indicator i
    ON f.indicator_id = i.indicator_id
LEFT JOIN mart.dim_date d
    ON f.date_id = d.date_id
ORDER BY
    c.country_name,
    i.indicator_code,
    d.year;
