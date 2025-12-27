from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

# creamos el DAG de controles de calidad de datos
with DAG(
    dag_id="10_data_quality_checks",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["quality"],
    template_searchpath="/opt/airflow/sql"
) as dag:

# esta es la tarea que ejecuta los checks de calidad sobre el modelo analítico
    quality_checks = PostgresOperator(
        task_id="run_data_quality_checks",
        postgres_conn_id="worldbank_postgres",
        sql="quality/data_quality_checks.sql"
    )
