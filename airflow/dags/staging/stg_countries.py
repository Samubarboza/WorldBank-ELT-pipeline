from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

# definimos el dag de staging, configuramos el flujo, cuando puede ejecutarse y como se comporta
with DAG(
    dag_id="stg_countries",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["staging"],
    template_searchpath="/opt/airflow/sql"
) as dag:

# esto es una tarea que ejecuta el SQL de staging en Postgres para construir stg_countries
    run_stg_countries = PostgresOperator(
        task_id="run_stg_countries",
        postgres_conn_id="worldbank_postgres",
        sql="staging/data/stg_countries_transformations.sql"
    )
