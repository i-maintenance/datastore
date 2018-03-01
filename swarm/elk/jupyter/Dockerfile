# Copyright (c) Salzburg Research

FROM jupyter/all-spark-notebook

LABEL maintainer="Christoph Schranz <iotlab@salzburgresarch.at>"

USER root

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  git wget python-pip unzip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


#ENV PYTHONPYTH /usr/bin/python3
ENV PYSPARK_PYTHON /opt/conda/bin/python
#ENV PYSPARK_DRIVER_PYTHON /usr/bin/python3


RUN pip install --no-cache-dir \
    elasticsearch==6.1.1 && \
    rm -rf /home/$NB_USER/.local && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


## installing es-hadoop
#RUN apt-get update && apt-get install -y --no-install-recommends git \
# && git clone https://github.com/elastic/elasticsearch-hadoop.git && cd elasticsearch-hadoop \
# && git checkout 6.2


#RUN $SPARK_HOME/bin/spark-shell --packages org.elasticsearch:elasticsearch-hadoop:6.2.1

#RUN git clone https://github.com/elastic/elasticsearch-hadoop.git

RUN apt-get update \
 && curl -sL http://central.maven.org/maven2/org/elasticsearch/elasticsearch-hadoop/6.2.1/elasticsearch-hadoop-6.2.1.jar


# Change jupyter_notebook_config.py
COPY jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py



