-- con esto se construye la dimension de años del Data Mart para analizar los datos en el tiempo sin repetir informacion
-- creamos la dimension de fechas con un registro unico por año - para tener los años centralizados y reutilizables en analisis
CREATE TABLE IF NOT EXISTS mart.dim_date (
    date_id BIGSERIAL PRIMARY KEY,
    year INT NOT NULL UNIQUE
);
-- insertamos los años unicos desde STAGING evitando duplicados
INSERT INTO mart.dim_date (year)
SELECT DISTINCT year
FROM stg.stg_indicator_values
ON CONFLICT (year) DO NOTHING;
