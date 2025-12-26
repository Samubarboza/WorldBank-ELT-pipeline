from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

with DAG(
    dag_id="bootstrap_db",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["bootstrap", "infra"],
    template_searchpath=[
        "/opt/airflow/dags",
        "/opt/airflow/scripts"
    ]
) as dag:

    bootstrap = PostgresOperator(
        task_id="bootstrap_database",
        postgres_conn_id="worldbank_postgres",
        sql="bootstrap.sql"
    )
