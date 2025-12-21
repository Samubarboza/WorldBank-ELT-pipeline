-- esto prepara la base de datos para el pipeline ELT creando los schemas y configuraciones basicas
-- crear schemas base del proyecto
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS mart;

-- extensiones utiles (seguras y comunes)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
