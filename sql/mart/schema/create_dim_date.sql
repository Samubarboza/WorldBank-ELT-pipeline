-- crea la tabla de dimensión fecha (solo estructura)
CREATE TABLE IF NOT EXISTS mart.dim_date (
    date_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    year INTEGER NOT NULL UNIQUE
);
