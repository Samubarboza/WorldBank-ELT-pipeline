-- crea la tabla de dimensión indicador (solo estructura)
CREATE TABLE IF NOT EXISTS mart.dim_indicator (
    indicator_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    indicator_code TEXT NOT NULL UNIQUE
);
