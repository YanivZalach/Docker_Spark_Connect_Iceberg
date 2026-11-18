# Standalone Hive metastore (thrift, port 9083) shared by Spark and Trino.
# 3.1.3 is the newest metastore version Spark 3.5's Hive client supports. The image is amd64 only.
FROM --platform=linux/amd64 apache/hive:3.1.3
USER root
# The bundled 9.4 driver can't do SCRAM auth, which Postgres 16 requires by default.
RUN rm /opt/hive/lib/postgresql-9.4.1208.jre7.jar
ADD --chown=hive:hive --chmod=644 \
    https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.4/postgresql-42.7.4.jar \
    /opt/hive/lib/postgresql-42.7.4.jar
COPY --chmod=755 docker/hive-metastore/start.sh /opt/start-metastore.sh
COPY docker/hive-metastore/hive-site.xml /opt/hive/conf/hive-site.xml
USER hive
ENTRYPOINT ["/opt/start-metastore.sh"]
