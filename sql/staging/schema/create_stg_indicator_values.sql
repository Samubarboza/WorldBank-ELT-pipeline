
CREATE TABLE IF NOT EXISTS stg.stg_indicator_values (
    indicator_id TEXT,
    indicator_name TEXT,
    country_code TEXT,
    country_name TEXT,
    year INTEGER,
    value NUMERIC,
    execution_date DATE
);
