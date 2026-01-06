CREATE TABLE IF NOT EXISTS stg.stg_indicator_values (
    indicator_code TEXT NOT NULL,
    country_code TEXT NOT NULL,
    year INTEGER NOT NULL,
    value NUMERIC,
    execution_date DATE NOT NULL,
    CONSTRAINT uq_stg_indicator_values UNIQUE (
        indicator_code,
        country_code,
        year,
        execution_date
    )
);
