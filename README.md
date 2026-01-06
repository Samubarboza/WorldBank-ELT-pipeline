📄 **Spanish version:** [README_ES.md](readme_es.md)

# World Bank ELT Pipeline

## Overview
This project implements an **ELT (Extract, Load, Transform) data pipeline** using official data from the **World Bank API**. The pipeline ingests raw socioeconomic data, stores it safely, transforms it inside a data warehouse, and exposes it in an analytical model ready for BI tools or analytical queries.

The design follows common data engineering patterns used in real production environments.

---

## Purpose
The pipeline enables analysis of how countries evolve over time using World Bank indicators such as:
- GDP (PIB)
- Inflation
- Unemployment
- Life expectancy
- Population

Examples of questions the model can answer:
- How did GDP change in Paraguay compared to neighboring countries over the last 20 years?
- What relationship can be observed between inflation and unemployment?
- Which countries improved life expectancy, and during which periods?

---

## Architecture
The project follows a **three-layer ELT architecture**:

### 1. RAW (Landing Zone)
- Stores raw JSON responses exactly as returned by the World Bank API
- No transformations are applied at this stage
- Used for traceability, auditing, and reprocessing

Each RAW table includes:
- `payload` (JSON)
- `source_system`
- `execution_date` (Airflow logical date)
- `ingestion_timestamp`
- `request_hash` (used for idempotency)

### 2. STAGING (Normalization Layer)
- Converts raw JSON into clean, typed, tabular structures
- Still close to the source, but usable for transformations
- Handles duplication control and basic consistency

Main tables:
- `stg_countries`
- `stg_indicators`
- `stg_indicator_values`

### 3. MART (Analytical Layer)
- Analytical model optimized for querying
- Dimensional-style schema

Dimensions:
- `dim_country`
- `dim_indicator`
- `dim_date`

Facts:
- `fact_indicator_values`

---

## Data Source
- World Bank Public API
- Official, non-fictitious data
- REST API returning JSON
- Pagination handled by the pipeline

The data arrives **raw and unclean**. Responses are deeply nested JSON structures that include metadata, mixed types, null values, and sparse records.

Example of a raw response fragment exactly as received:

```json
[
  {
    "page": 1,
    "pages": 1,
    "per_page": 50,
    "total": 1
  },
  [
    {
      "indicator": {"id": "NY.GDP.MKTP.CD", "value": "GDP (current US$)"},
      "country": {"id": "PRY", "value": "Paraguay"},
      "countryiso3code": "PRY",
      "date": "2024",
      "value": 44458118397,
      "unit": "",
      "obs_status": "",
      "decimal": 0
    },
    {
      "indicator": {"id": "NY.GDP.MKTP.CD", "value": "GDP (current US$)"},
      "country": {"id": "PRY", "value": "Paraguay"},
      "countryiso3code": "PRY",
      "date": "2023",
      "value": null,
      "unit": "",
      "obs_status": "",
      "decimal": 0
    }
  ]
]
```

Characteristics of the raw data:
- Metadata and data mixed in the same response
- Nested objects (`indicator`, `country`)
- Frequent `null` values
- Inconsistent completeness across years
- Not suitable for analytics without transformation

This is why the pipeline strictly separates RAW ingestion from STAGING and MART transformations.

---

## ELT Flow

1. Extract
   - Airflow tasks call the World Bank API
   - Pagination is handled automatically
   - Requests are executed per country, indicator, and execution date

2. Load (RAW)
   - Raw JSON is inserted into PostgreSQL
   - Inserts are idempotent using `request_hash`
   - Re-running the same execution date does not duplicate data

3. Transform (STAGING and MART)
   - Transformations are executed inside the data warehouse using SQL
   - Python is not used for heavy transformations
   - Data is cleaned, typed, and modeled for analytics

---

## Tech Stack

- Python 3
- PostgreSQL 15
- Apache Airflow 2.9
- Docker and Docker Compose
- SQL (PostgreSQL dialect)
- JSON

Libraries:
- `requests`
- `psycopg2`
- `pandas` (used only for exports, not transformations)

---

## Project Structure

```
World-Bank-ELT-Pipeline/
│
├── airflow/
│   ├── dags/              # Airflow DAG definitions
│   ├── logs/
│   └── plugins/
│
├── sql/
│   ├── raw/               # RAW table definitions
│   ├── staging/           # STAGING transformations
│   ├── mart/              # DIM and FACT models
│   └── data_quality/      # Data quality checks
│
├── scripts/               # Python extraction logic
│
├── docker-compose.yml
├── .env.example
└── README.md
```

---

## Partitioning Strategy

The table `fact_indicator_values` is partitioned by **year**.

Reasons:
- World Bank data is naturally time-based
- Faster analytical queries
- Efficient historical backfills
- Easier maintenance as data volume grows

The `execution_date` is stored separately for audit and lineage purposes.

---

## Idempotency

The pipeline is safe to re-run.

- Each API request generates a `request_hash`
- RAW inserts use conflict control
- Re-running the same execution date does not generate duplicates

This allows safe retries, backfills, and recovery from failures.

---

## Data Quality Checks

Before finishing a run, SQL validations ensure:
- No NULL keys (`country`, `indicator`, `year`)
- Year values are within a valid range (>= 1960 and <= current year)
- No invalid negative values

If any rule fails, the DAG fails intentionally.

---

## How to Run the Project

### Requirements
- Docker
- Docker Compose

### Environment Variables

Copy and edit:

```
cp .env.example .env
```

### Start the Platform

```
docker compose up -d
```

---

## Airflow Configuration (Required)

Before executing the DAGs, a **PostgreSQL connection must be created in the Airflow UI**.

Steps:
1. Open Airflow UI at `http://localhost:8080`
2. Go to **Admin → Connections**
3. Create a new connection with:
   - Connection ID: `worldbank_postgres`
   - Connection Type: `Postgres`
   - Host: `postgres` (Docker service name)
   - Schema: database name
   - Login / Password: as defined in `.env`
   - Port: `5432`

Without this connection, the DAGs will not be able to access the warehouse.

---

## Output

After a successful run:
- RAW tables contain auditable JSON data
- STAGING tables contain normalized, typed data
- MART tables are ready for BI tools (Power BI, notebooks, SQL clients)

---

## Author

Built to demonstrate a complete ELT pipeline using public data and standard data engineering practices.

