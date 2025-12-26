-- crea la tabla de hechos del Data Mart (solo estructura)
CREATE TABLE IF NOT EXISTS mart.fact_indicator_values (
    country_id BIGINT NOT NULL,
    indicator_id BIGINT NOT NULL,
    date_id BIGINT NOT NULL,

    year INTEGER NOT NULL,
    value NUMERIC,
    execution_date DATE NOT NULL,

    CONSTRAINT fk_country
        FOREIGN KEY (country_id) REFERENCES mart.dim_country(country_id),
    CONSTRAINT fk_indicator
        FOREIGN KEY (indicator_id) REFERENCES mart.dim_indicator(indicator_id),
    CONSTRAINT fk_date
        FOREIGN KEY (date_id) REFERENCES mart.dim_date(date_id),

    PRIMARY KEY (country_id, indicator_id, year)
);
