FROM quay.io/jupyter/base-notebook:python-3.12
RUN pip install --no-cache-dir \
      "pyspark[connect]==3.5.4" \
      "setuptools>=75.0.0" \
      nbclassic

# Start the classic Notebook UI instead of JupyterLab
ENV DOCKER_STACKS_JUPYTER_CMD=nbclassic
