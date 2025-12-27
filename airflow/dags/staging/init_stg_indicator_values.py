from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

with DAG(
    dag_id="05_init_stg_indicator_values",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
    tags=["init", "staging"],
    template_searchpath="/opt/airflow/sql"
) as dag:

    create_stg_indicator_values = PostgresOperator(
        task_id="create_stg_indicator_values",
        postgres_conn_id="worldbank_postgres",
        sql="staging/schema/create_stg_indicator_values.sql"
    )
