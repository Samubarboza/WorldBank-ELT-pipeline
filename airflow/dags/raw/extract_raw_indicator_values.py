from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime
import requests
import json
import hashlib

# funcion para extraer los valores del indicador desde la API del World Bank y guarda el JSON crudo en la tabla RAW
def extract_indicator_values_raw(execution_date, **context):
    
    # configuracion basica 
    # codigo del pais
    country_code = "PRY"
    # indicador economico (PIB en usd)
    indicator_code = "NY.GDP.MKTP.CD"
    # nombre del sistema fuente
    source_system = "world_bank"
    # Fecha lógica del DAG (Airflow-native, no Proxy)
    execution_date = context["logical_date"].date().isoformat()

    page = 1
    all_pages = []
# mientras existan paginas, vamos a seguir ejecutando - utilizamos esto para extraer los datos de todas las paginas
    while True:
        url = (
            f"https://api.worldbank.org/v2/country/{country_code}/indicator/{indicator_code}"
            f"?format=json&page={page}"
        )

        response = requests.get(url)
        response.raise_for_status()
        data = response.json()

        all_pages.append(data)

        metadata = data[0]
        total_pages = metadata.get("pages")

        if page >= total_pages:
            break

        page += 1

    # esto genera un hash unico del request para evitar insertar datos duplicados
    request_string = f"{country_code}_{indicator_code}_{execution_date}"
    request_hash = hashlib.md5(request_string.encode()).hexdigest()

    # Sentencia SQL para insertar datos crudos en la tabla RAW con control de duplicados
    insert_sql = """
        INSERT INTO raw.raw_indicator_values (
            payload,
            source_system,
            execution_date,
            request_hash
        )
        VALUES (%s, %s, %s, %s)
        ON CONFLICT (request_hash) DO NOTHING;
    """

    # ejecutamos la sentencia SQL en Postgres pasando los datos como parámetros seguros
    pg_hook = PostgresHook(postgres_conn_id="worldbank_postgres")
    pg_hook.run(
        insert_sql,
        parameters=[
            json.dumps(all_pages),
            source_system,
            execution_date,
            request_hash
        ]
    )

# definimos el dag y la forma de ejecucion
with DAG(
    dag_id="03_extract_raw_indicator_values",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["raw", "world_bank"]
) as dag:

    extract_task = PythonOperator(
        task_id="extract_indicator_values_raw",
        python_callable=extract_indicator_values_raw,
        provide_context=True
    )
