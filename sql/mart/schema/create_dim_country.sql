-- crea la tabla de dimensión país en MART (solo estructura)
CREATE TABLE IF NOT EXISTS mart.dim_country (
    country_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    country_code TEXT NOT NULL UNIQUE,
    country_name TEXT,
    region TEXT,
    income_level TEXT
);
