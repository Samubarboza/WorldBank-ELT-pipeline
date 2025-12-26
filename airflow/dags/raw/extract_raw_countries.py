from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime
import requests
import json
import hashlib

# funciona para extraer los datos crudo de la api e irsertar datos en la tabla 
def extract_countries_raw(execution_date, **context):
    execution_date = context["logical_date"].isoformat()
    # aca hacemos la llamada a la api
    url = "https://api.worldbank.org/v2/country?format=json&per_page=400"
    response = requests.get(url)
    response.raise_for_status()
    payload = response.json()

    # metadata
    source_system = "world_bank"

    request_string = f"countries_{execution_date}"
    request_hash = hashlib.md5(request_string.encode()).hexdigest()

    # insertar crudo a la tabla
    insert_sql = """
        INSERT INTO raw.raw_countries (
            payload,
            source_system,
            execution_date,
            request_hash
        )
        VALUES (%s, %s, %s, %s)
        ON CONFLICT (request_hash) DO NOTHING;
    """

    pg_hook = PostgresHook(postgres_conn_id="worldbank_postgres")
    pg_hook.run(
        insert_sql,
        parameters=[
            json.dumps(payload),
            source_system,
            execution_date,
            request_hash
        ]
    )

# dag airflow para ejecutar la funcion de extraccion
with DAG(
    dag_id="extract_raw_countries",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["raw", "world_bank"]
) as dag:

    extract_task = PythonOperator(
        task_id="extract_countries_raw",
        python_callable=extract_countries_raw,
        provide_context=True
    )