from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
from utils.export.export_world_bank_to_excel import export_world_bank_to_excel

with DAG(
    dag_id="export_world_bank_to_excel",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,   # DAG manual
    catchup=False,
    tags=["export", "excel"],
) as dag:

    export_to_excel = PythonOperator(
        task_id="export_world_bank_data",
        python_callable=export_world_bank_to_excel
    )
