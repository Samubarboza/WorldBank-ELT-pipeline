# World Bank ELT Pipeline

## Descripción general
Este proyecto implementa un **pipeline ELT (Extract, Load, Transform)** utilizando datos oficiales del **World Bank API**. El pipeline ingesta datos socioeconómicos crudos, los almacena de forma segura, los transforma dentro de un data warehouse y los expone en un modelo analítico listo para ser consultado desde herramientas de BI o mediante SQL.

El diseño sigue patrones comunes de ingeniería de datos utilizados en entornos reales de producción.

---

## Objetivo
El pipeline permite analizar cómo evolucionan los países a lo largo del tiempo utilizando indicadores del Banco Mundial, como:
- PIB
- Inflación
- Desempleo
- Esperanza de vida
- Población

Ejemplos de preguntas que este modelo puede responder:
- ¿Cómo cambió el PIB de Paraguay frente a países vecinos en los últimos 20 años?
- ¿Qué relación se observa entre inflación y desempleo?
- ¿Qué países mejoraron su esperanza de vida y en qué períodos?

---

## Arquitectura
El proyecto sigue una arquitectura ELT de **tres capas**:

### 1. RAW (Zona de aterrizaje)
- Almacena las respuestas JSON crudas exactamente como las devuelve la API
- No se aplican transformaciones en esta etapa
- Se utiliza para trazabilidad, auditoría y reprocesos

Cada tabla RAW incluye:
- `payload` (JSON)
- `source_system`
- `execution_date` (fecha lógica de Airflow)
- `ingestion_timestamp`
- `request_hash` (clave de idempotencia)

### 2. STAGING (Normalización)
- Convierte el JSON crudo en estructuras tabulares limpias y tipadas
- Sigue estando cerca de la fuente, pero ya es usable
- Controla duplicados y consistencia básica

Tablas principales:
- `stg_countries`
- `stg_indicators`
- `stg_indicator_values`

### 3. MART (Capa analítica)
- Modelo optimizado para consultas analíticas
- Esquema de tipo dimensional

Dimensiones:
- `dim_country`
- `dim_indicator`
- `dim_date`

Hechos:
- `fact_indicator_values`

---

## Fuente de datos
- World Bank Public API
- Datos oficiales, reales (no ficticios)
- API REST que devuelve JSON
- La paginación es manejada por el pipeline

Los datos llegan **crudos y sucios**. Las respuestas son estructuras JSON profundamente anidadas, con metadata mezclada con datos, valores nulos y registros incompletos.

Ejemplo real de cómo llegan los datos:

```json
[
  {
    "page": 1,
    "pages": 1,
    "per_page": 50,
    "total": 1
  },
  [
    {
      "indicator": {"id": "NY.GDP.MKTP.CD", "value": "GDP (current US$)"},
      "country": {"id": "PRY", "value": "Paraguay"},
      "countryiso3code": "PRY",
      "date": "2024",
      "value": 44458118397,
      "unit": "",
      "obs_status": "",
      "decimal": 0
    },
    {
      "indicator": {"id": "NY.GDP.MKTP.CD", "value": "GDP (current US$)"},
      "country": {"id": "PRY", "value": "Paraguay"},
      "countryiso3code": "PRY",
      "date": "2023",
      "value": null,
      "unit": "",
      "obs_status": "",
      "decimal": 0
    }
  ]
]
```

Por esta razón el pipeline separa estrictamente las capas RAW, STAGING y MART.

---

## Flujo ELT

1. **Extract**
   - Airflow consulta la API del Banco Mundial
   - Se maneja la paginación automáticamente
   - Las requests se ejecutan por país, indicador y fecha lógica

2. **Load (RAW)**
   - El JSON crudo se inserta en PostgreSQL
   - Las inserciones son idempotentes mediante `request_hash`
   - Reejecutar la misma fecha no duplica datos

3. **Transform (STAGING y MART)**
   - Las transformaciones se ejecutan dentro del warehouse usando SQL
   - Python no se usa para transformaciones pesadas
   - Los datos quedan limpios y listos para análisis

---

## Stack tecnológico

- Python 3
- PostgreSQL 15
- Apache Airflow 2.9
- Docker y Docker Compose
- SQL (PostgreSQL)
- JSON

Librerías:
- `requests`
- `psycopg2`
- `pandas` (solo para exportaciones)

---

## Estructura del proyecto

```
World-Bank-ELT-Pipeline/
│
├── airflow/
│   ├── dags/
│   ├── logs/
│   └── plugins/
│
├── sql/
│   ├── raw/
│   ├── staging/
│   ├── mart/
│   └── data_quality/
│
├── scripts/
├── docker-compose.yml
├── .env.example
├── README.md
└── README_ES.md
```

---

## Particionamiento

La tabla `fact_indicator_values` está particionada por **año**.

Motivos:
- Los datos son naturalmente temporales
- Consultas más rápidas
- Backfills históricos eficientes
- Mejor mantenimiento a largo plazo

`execution_date` se conserva para auditoría y trazabilidad.

---

## Idempotencia

El pipeline puede reejecutarse de forma segura:
- Cada request genera un `request_hash`
- Las inserciones controlan conflictos
- No se generan duplicados

---

## Data Quality

Antes de finalizar una corrida, se validan reglas SQL:
- Claves no nulas
- Años válidos (>= 1960 y <= año actual)
- Valores negativos inválidos

Si alguna regla falla, el DAG falla intencionalmente.

---

## Cómo ejecutar el proyecto

### Requisitos
- Docker
- Docker Compose

### Variables de entorno

```bash
cp .env.example .env
```

### Levantar la plataforma

```bash
docker compose up -d
```

---

## Configuración de Airflow (obligatorio)

Antes de ejecutar los DAGs es necesario **crear la conexión a PostgreSQL en la UI de Airflow**.

Pasos:
1. Abrir Airflow en `http://localhost:8080`
2. Ir a **Admin → Connections**
3. Crear una conexión con:
   - Connection ID: `worldbank_postgres`
   - Type: `Postgres`
   - Host: `postgres`
   - Schema: nombre de la base
   - Usuario / contraseña: definidos en `.env`
   - Puerto: `5432`

Sin esta conexión, los DAGs no pueden acceder al warehouse.

---

## Resultado

Luego de una ejecución exitosa:
- RAW contiene JSON crudo auditable
- STAGING contiene datos normalizados
- MART queda listo para BI, notebooks o consultas SQL

---

## Autor

Pipeline ELT construido con datos públicos y prácticas estándar de ingeniería de datos.

