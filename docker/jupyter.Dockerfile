FROM quay.io/jupyter/base-notebook:python-3.12
# Spark 3.5 Connect needs pandas < 2.3 and pyarrow < 18 (which still supports NumPy 1.x);
# unpinned installs pull pandas 3 / pyarrow 26 and fail at import time.
RUN pip install --no-cache-dir \
      "pyspark[connect]==3.5.4" \
      "numpy<2" \
      "pandas>=1.4.4,<2.3" \
      "pyarrow>=4,<18" \
      "setuptools>=75.0.0" \
      "psycopg[binary]>=3.2,<3.3" \
      "trino>=0.330,<1" \
      nbclassic

# Start the classic Notebook UI instead of JupyterLab
ENV DOCKER_STACKS_JUPYTER_CMD=nbclassic
