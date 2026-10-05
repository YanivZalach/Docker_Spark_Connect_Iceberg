CREATE DATABASE hive_metastore;
\c hive_metastore
\cd /docker-entrypoint-initdb.d/hive
\i hive-schema-2.3.0.postgres.sql
