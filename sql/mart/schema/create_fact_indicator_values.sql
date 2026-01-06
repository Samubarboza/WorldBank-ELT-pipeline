CREATE TABLE IF NOT EXISTS mart.fact_indicator_values (
    country_id BIGINT NOT NULL,
    indicator_id BIGINT NOT NULL,
    date_id BIGINT NOT NULL,
    year INTEGER NOT NULL,
    value NUMERIC NOT NULL,
    execution_date DATE NOT NULL,

    CONSTRAINT fk_country
        FOREIGN KEY (country_id) REFERENCES mart.dim_country(country_id),
    CONSTRAINT fk_indicator
        FOREIGN KEY (indicator_id) REFERENCES mart.dim_indicator(indicator_id),
    CONSTRAINT fk_date
        FOREIGN KEY (date_id) REFERENCES mart.dim_date(date_id),

    CONSTRAINT chk_fact_year
        CHECK (year BETWEEN 1960 AND EXTRACT(YEAR FROM CURRENT_DATE)),

    CONSTRAINT chk_fact_value
        CHECK (value >= 0),

    PRIMARY KEY (country_id, indicator_id, year, execution_date)
);
