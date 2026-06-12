# Spark + Iceberg Demo Stack

A small Docker Compose environment for experimenting with Apache Spark and Apache Iceberg, with a Jupyter notebook server for running code against it.

## What's inside

```
.
├── docker-compose.yml          # The whole stack
├── notebooks/
│   └── iceberg_demo_seed.ipynb # Notebook that creates demo Iceberg tables
└── data/                       # Iceberg warehouse (created on first run)
```

## Services

The compose file starts four containers:

- **spark-master** — Spark standalone master. Web UI at http://localhost:8080
- **spark-worker** — A worker attached to the master
- **spark-connect** — Spark Connect server with the Iceberg runtime and Avro jars installed. Listens on `localhost:15002` (gRPC), Spark UI at http://localhost:4040. Uses a Hadoop catalog with the warehouse at `./data`
- **jupyter** — JupyterLab (Python 3.12 with `pyspark[connect]` 3.5.4) at http://localhost:8888, no token. Notebooks are stored in `./notebooks` on the host

## Quick start

```bash
mkdir -p notebooks data
docker compose up --build
```

Then open http://localhost:8888 and run `iceberg_demo_seed.ipynb`.

## Cleanup

```bash
docker compose down
rm -rf data    # wipe the warehouse
```
