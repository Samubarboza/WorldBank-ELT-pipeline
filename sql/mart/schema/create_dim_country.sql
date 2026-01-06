CREATE TABLE IF NOT EXISTS mart.dim_country (
    country_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    country_code TEXT NOT NULL UNIQUE,
    country_name TEXT NOT NULL,
    region TEXT,
    income_level TEXT
);
