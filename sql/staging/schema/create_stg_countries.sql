-- creamos la tabla stg_countries dentro del schema stg en la db
CREATE TABLE IF NOT EXISTS stg.stg_countries (
    country_code TEXT NOT NULL,
    country_name TEXT,
    region TEXT,
    income_level TEXT,
    execution_date DATE NOT NULL,
    CONSTRAINT uq_stg_countries UNIQUE (country_code, execution_date)
);
