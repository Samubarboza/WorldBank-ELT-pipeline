-- aca se crea la tabla de hechos donde se guardan los valores del indicador, conectados a pais, indicador y año, listos para analisis eficiente
-- creamos la tabla de hechos para almacenar los valores del indicador
CREATE TABLE IF NOT EXISTS mart.fact_indicator_values (
    -- referencias a las dimensiones de pais, indicador y fecha
    country_id BIGINT NOT NULL,
    indicator_id BIGINT NOT NULL,
    date_id BIGINT NOT NULL,

    -- guardamos el año, el valor del indicador y la fecha de carga
    year INT NOT NULL,
    value FLOAT,

    execution_date DATE NOT NULL,

    -- aseguramos la relacion correcta con las tablas de dimensiones - evitamos datos invalidos y mantenemos consistencia
    CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES mart.dim_country(country_id),
    CONSTRAINT fk_indicator FOREIGN KEY (indicator_id) REFERENCES mart.dim_indicator(indicator_id),
    CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES mart.dim_date(date_id)
)
-- particiona la tabla por año para mejorar rendimiento - para mejora rendimiento y escalabilidad cuando crezcan los datos
PARTITION BY RANGE (year);
