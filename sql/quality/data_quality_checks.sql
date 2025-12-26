-- filas con claves nulas
DO $$
BEGIN
    IF (
        SELECT COUNT(*)
        FROM mart.fact_indicator_values
        WHERE country_id IS NULL
            OR indicator_id IS NULL
            OR year IS NULL
    ) > 0 THEN
        RAISE EXCEPTION 'Data quality failed: NULL keys found';
    END IF;
END $$;

-- años fuera de rango
DO $$
BEGIN
    IF (
        SELECT COUNT(*)
        FROM mart.fact_indicator_values
        WHERE year < 1960
            OR year > EXTRACT(YEAR FROM CURRENT_DATE)
    ) > 0 THEN
        RAISE EXCEPTION 'Data quality failed: invalid years';
    END IF;
END $$;

-- valores negativos
DO $$
BEGIN
    IF (
        SELECT COUNT(*)
        FROM mart.fact_indicator_values
        WHERE value < 0
    ) > 0 THEN
        RAISE EXCEPTION 'Data quality failed: negative values';
    END IF;
END $$;
