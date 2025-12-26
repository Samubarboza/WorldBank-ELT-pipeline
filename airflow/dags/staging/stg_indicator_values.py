# importamos las clases necesarias para definir un DAG y ejecutar SQL en Postgres
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

# definimos el DAG de staging para los valores de indicadores
with DAG(
    dag_id="stg_indicator_values",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["staging"],
    template_searchpath="/opt/airflow/sql"
) as dag:

# Tarea que ejecuta el SQL de staging para construir stg_indicator_values
    run_stg_indicator_values = PostgresOperator(
        task_id="run_stg_indicator_values",
        postgres_conn_id="worldbank_postgres",
        sql="staging/data/stg_indicator_values.sql"
    )
