from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime


# DAG encargado de construir el modelo analitico (MART)
with DAG(
    dag_id="09_build_mart",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["mart"],
    template_searchpath="/opt/airflow/sql"
) as dag:

# con esto construimos la dimension de los paises
    dim_country = PostgresOperator(
        task_id="dim_country",
        postgres_conn_id="worldbank_postgres",
        sql="mart/data/dim_country.sql"
    )

# construimos la dimension de los indicadores
    dim_indicator = PostgresOperator(
        task_id="dim_indicator",
        postgres_conn_id="worldbank_postgres",
        sql="mart/data/dim_indicator.sql"
    )

# construimos la dimension de fechas
    dim_date = PostgresOperator(
        task_id="dim_date",
        postgres_conn_id="worldbank_postgres",
        sql="mart/data/dim_date.sql"
    )

# construimos la tabla de hechos con los valores de los indicadores
    fact = PostgresOperator(
        task_id="fact_indicator_values",
        postgres_conn_id="worldbank_postgres",
        sql="mart/data/fact_indicator_values.sql"
    )
