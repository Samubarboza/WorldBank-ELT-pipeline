import pandas as pd
from airflow.providers.postgres.hooks.postgres import PostgresHook
from pathlib import Path


def export_world_bank_to_excel(execution_date: str) -> None:
    # 1. Conexión al warehouse
    postgres_hook = PostgresHook(postgres_conn_id="worldbank_postgres")

    # 2. Paths SQL
    sql_base_path = Path("/opt/airflow/sql/export")
    countries_sql = (sql_base_path / "export_countries.sql").read_text()
    indicator_values_sql = (sql_base_path / "export_indicator_values.sql").read_text()

    # 3. Ejecutar queries
    countries_df = postgres_hook.get_pandas_df(countries_sql)
    indicator_values_df = postgres_hook.get_pandas_df(indicator_values_sql)

    # 4. Output path
    output_dir = Path("/opt/airflow/data/excel")
    output_dir.mkdir(parents=True, exist_ok=True)

    output_file = output_dir / f"world_bank_{execution_date}.xlsx"

    # 5. Escribir Excel con dos hojas
    with pd.ExcelWriter(output_file, engine="openpyxl") as writer:
        countries_df.to_excel(writer, sheet_name="countries", index=False)
        indicator_values_df.to_excel(writer, sheet_name="indicator_values", index=False)
