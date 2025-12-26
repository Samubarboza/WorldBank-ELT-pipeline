from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

with DAG(
    dag_id="init_stg_countries_tables",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@once",
    catchup=False,
    tags=["init", "staging"],
    template_searchpath="/opt/airflow/sql"
) as dag:

    create_stg_tables = PostgresOperator(
        task_id="create_stg_tables",
        postgres_conn_id="worldbank_postgres",
        sql="staging/schema/create_stg_countries.sql"
    )
