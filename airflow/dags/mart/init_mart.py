from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

with DAG(
    dag_id="init_mart",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@once",
    catchup=False,
    tags=["init", "mart"],
    template_searchpath="/opt/airflow/sql"
) as dag:

    create_dim_country = PostgresOperator(
        task_id="create_dim_country",
        postgres_conn_id="worldbank_postgres",
        sql="mart/schema/create_dim_country.sql"
    )

    create_dim_indicator = PostgresOperator(
        task_id="create_dim_indicator",
        postgres_conn_id="worldbank_postgres",
        sql="mart/schema/create_dim_indicator.sql"
    )

    create_dim_date = PostgresOperator(
        task_id="create_dim_date",
        postgres_conn_id="worldbank_postgres",
        sql="mart/schema/create_dim_date.sql"
    )

    create_fact_indicator_values = PostgresOperator(
        task_id="create_fact_indicator_values",
        postgres_conn_id="worldbank_postgres",
        sql="mart/schema/create_fact_indicator_values.sql"
    )

    (
        [create_dim_country, create_dim_indicator, create_dim_date]
        >> create_fact_indicator_values
    )
