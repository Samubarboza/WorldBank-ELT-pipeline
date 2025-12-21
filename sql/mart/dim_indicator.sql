-- con esto crea y mantiene la lista unica de indicadores del Data Mart para usarlos en analisis.

-- creamos la dimension de indicadores con un registro unico por indicador
CREATE TABLE IF NOT EXISTS mart.dim_indicator (
    indicator_id BIGSERIAL PRIMARY KEY,
    indicator_code TEXT NOT NULL UNIQUE
);
-- insertamos indicadores unicos desde STAGING evitando duplicados
INSERT INTO mart.dim_indicator (indicator_code)
SELECT DISTINCT indicator_code
FROM stg.stg_indicator_values
ON CONFLICT (indicator_code) DO NOTHING;
