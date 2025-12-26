CREATE TABLE IF NOT EXISTS raw.raw_countries (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    payload JSONB NOT NULL,
    source_system TEXT NOT NULL,
    execution_date DATE NOT NULL,
    ingestion_timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    request_hash TEXT NOT NULL,
    CONSTRAINT uq_raw_countries_request UNIQUE (request_hash)
);

CREATE TABLE IF NOT EXISTS raw.raw_indicator_values (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    payload JSONB NOT NULL,
    source_system TEXT NOT NULL,
    execution_date DATE NOT NULL,
    ingestion_timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    request_hash TEXT NOT NULL,
    CONSTRAINT uq_raw_indicator_values_request UNIQUE (request_hash)
);
