from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

# definimos las configuraciones del dag (ejecucion manual)
with DAG(
    dag_id="01_init_raw_tables",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
    tags=["init", "raw"],
    template_searchpath="/opt/airflow/sql"
) as dag:

# tarea que va a ejecutar este dag - va a crear las tablas para los datos crudos, ejecuta script sql definido dentro de raw
    create_raw_tables = PostgresOperator(
        task_id="create_raw_tables",
        postgres_conn_id="worldbank_postgres",
        sql="raw/create_raw_tables.sql"
    )
