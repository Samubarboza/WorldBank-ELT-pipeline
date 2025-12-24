-- contamos filas donde faltan claves basicas
SELECT COUNT(*) AS invalid_rows
FROM mart.fact_indicator_values
WHERE country_id IS NULL
    OR indicator_id IS NULL
    OR year IS NULL;

-- detectamos años imposibles
SELECT COUNT(*) AS invalid_years
FROM mart.fact_indicator_values
WHERE year < 1960
    OR year > EXTRACT(YEAR FROM CURRENT_DATE);

-- buscamos indicadores con valores negativos
SELECT COUNT(*) AS negative_values
FROM mart.fact_indicator_values
WHERE value < 0;


-- usamos estos para tener un control de la calidad de los datos, verficamos los datos finales quey ya estan en el mart