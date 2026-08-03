FROM apache/spark:3.5.4
USER root
RUN curl -fL -o /opt/spark/jars/iceberg-spark-runtime-3.5_2.12-1.10.1.jar \
      "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/1.10.1/iceberg-spark-runtime-3.5_2.12-1.10.1.jar" \
    && curl -fL -o /opt/spark/jars/spark-avro_2.12-3.5.4.jar \
      "https://repo1.maven.org/maven2/org/apache/spark/spark-avro_2.12/3.5.4/spark-avro_2.12-3.5.4.jar"
