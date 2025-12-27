-- preparamos la base de datos -  creamos schemas para cada cada cosa, separar responsabilidades y no tener todo mezclado en la base de datos
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS mart;
