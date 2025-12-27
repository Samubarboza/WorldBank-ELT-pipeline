from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

# este dag lee la el script sql que crea los schema y prepara configuraciones para la base de datos
with DAG(
    dag_id="00_bootstrap_db",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["bootstrap", "infra"],
    template_searchpath=[
        "/opt/airflow/dags",
        "/opt/airflow/scripts"
    ]
) as dag:

    # tarea que ejecuta el dag - se conecta a postgres y ejecuta el script bootstrap.sql.
    bootstrap = PostgresOperator(
        task_id="bootstrap_database",
        postgres_conn_id="worldbank_postgres",
        sql="bootstrap.sql"
    )
