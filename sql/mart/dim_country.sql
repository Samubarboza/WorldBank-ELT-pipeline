-- creo la tabla de paises para el Data Mart usando datos ya limpios, evitando duplicados y dejando todo listo para analisis

-- creamos la dimension de paises con una fila unica por pais
CREATE TABLE IF NOT EXISTS mart.dim_country (
    country_id BIGSERIAL PRIMARY KEY,
    country_code TEXT NOT NULL UNIQUE,
    country_name TEXT,
    region TEXT,
    income_level TEXT
);

-- insertamos datos unicos de paises en la dimension
INSERT INTO mart.dim_country (
    country_code,
    country_name,
    region,
    income_level
)
-- seleccionamos paises unicos desde la capa STAGING -  usamos distinct para evitar duplicados
SELECT DISTINCT
    country_code,
    country_name,
    region,
    income_level
FROM stg.stg_countries
-- evitamos duplicar paises si ya existen en la dimension -  permite correr el proceso varias veces sin romper nada
ON CONFLICT (country_code) DO NOTHING;
