from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

with DAG(
    dag_id="init_raw_tables",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@once",
    catchup=False,
    tags=["init", "raw"],
    template_searchpath="/opt/airflow/sql"
) as dag:

    create_raw_tables = PostgresOperator(
        task_id="create_raw_tables",
        postgres_conn_id="worldbank_postgres",
        sql="raw/create_raw_tables.sql"
    )
