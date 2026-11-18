# Spark + Iceberg Demo Stack

A small Docker Compose environment for experimenting with Apache Spark and Apache Iceberg, with a Jupyter notebook server for running code against it.

## What's inside

```
.
├── docker-compose.yml           # The whole stack
├── notebooks/
│   └── iceberg_demo_tables.ipynb # Notebook that creates demo Iceberg tables
└── data/                        # Iceberg warehouse (created on first run)
```

## Services

The compose file starts these containers:

- **spark-master** — Spark standalone master. Web UI at http://localhost:8080
- **spark-worker** — A worker attached to the master
- **postgres** — Shared Postgres instance: the `nessie` DB backs Nessie's catalog metadata (branches, table/view pointers, commit history), and the `hive_metastore` DB backs Spark's Hive metastore
- **nessie** — Project Nessie REST catalog server. API at http://localhost:19120/api/v2, backed by `postgres` via a JDBC version store, so catalog state survives `docker compose down` / `up`
- **spark-connect** — Spark Connect server with the Iceberg runtime and Avro jars installed. Listens on `localhost:15002` (gRPC), Spark UI at http://localhost:4040. Uses Nessie as the default `nessie` catalog for Iceberg tables, with the warehouse backed by `./data`. `spark_catalog` is Spark's own Hive session catalog, used for non-Iceberg tables; it talks to `hive-metastore`, and its table data lives in `./data/hive`
- **hive-metastore** (Hive 3.1.3, amd64 image, emulated on Apple Silicon): standalone thrift metastore at `thrift://hive-metastore:9083`, shared by Spark and Trino. Backed by the `hive_metastore` database in `postgres`. On startup it creates the schema if the database is empty, or upgrades an older one (such as the 2.3.0 schema earlier versions of this stack used) to 3.1.0
- **trino** (Trino 484): SQL engine over the same warehouse. Web UI and HTTP API at http://localhost:8090. Catalog `nessie` is the Nessie Iceberg catalog and catalog `hive` is the Hive metastore, so tables written by either engine are visible to the other (`nessie.default.events`, `hive.default.legacy_orders`). Query it with `docker compose exec trino trino`, or from Jupyter with the `trino` Python client at `http://trino:8080`. Spark runs with `spark.sql.iceberg.vectorization.enabled=false` because its vectorized Parquet reader can't decode the `DELTA_LENGTH_BYTE_ARRAY` string encoding Trino writes
- **jupyter** — classic Jupyter Notebook UI via NbClassic (Python 3.12 with `pyspark[connect]` 3.5.4) at http://localhost:8888, no token. Notebooks are stored in `./notebooks` on the host

## Quick start

```bash
mkdir -p notebooks data
docker compose up --build
```

Then open http://localhost:8888 and run `iceberg_demo_tables.ipynb`.

## Persistence

Catalog metadata lives in the `postgres-data` named volume, and table data files live in `./data` on the host. Both survive `docker compose down`, so tables are still there on the next `docker compose up`. To wipe everything:

```bash
docker compose down -v   # drops the postgres-data volume too
rm -rf data               # wipe the warehouse
```

## Cleanup

```bash
docker compose down
```
