# Data-Stack composed by Elastic Stack, Grafana, Jupyter, Spark and DB-adapter to stream data from a kafka broker


Based on the following Components: (based on [deviantony's work](https://github.com/deviantony/docker-elk))
* [Elasticsearch 6.2](https://github.com/elastic/elasticsearch-docker)
* [Logstash 6.2](https://github.com/elastic/logstash-docker)
* [Kibana 6.2](https://github.com/elastic/kibana-docker)
* [Grafana 5](http://docs.grafana.org/)
* [Spark 2.1.1](http://spark.apache.org/docs/2.1.1)
* [Hadoop 2.7.3](http://hadoop.apache.org/docs/r2.7.3)
* [PySpark](http://spark.apache.org/docs/2.1.1/api/python)
* [Anaconda3-5](https://www.anaconda.com/distribution/)


Plus the Kafka Adapter based on the components:
* Kafka Client [librdkafka](https://github.com/geeknam/docker-confluent-python) version **0.11.1**
* python kafka module [confluent-kafka-python](https://github.com/confluentinc/confluent-kafka-python) version **0.9.1.2**


## Contents

1. [Requirements](#requirements)
2. [Getting started](#getting-started)
3. [Storage](#storage)
   * [How can I persist Elasticsearch data?](#how-can-i-persist-elasticsearch-data)


## Requirements

1. Install [Docker](https://www.docker.com/community-edition#/download) version **1.10.0+**
2. Install [Docker Compose](https://docs.docker.com/compose/install/) version **1.6.0+**
3. Clone this repository


## Getting Started

This repository is divided into a swarm path and compose path, where the compose path
serves as a staging environment.

### Local deployment
Start the Data-Stack in a local testing environment using `docker-compose`:

```bash
cd swarm/dataStack/
sudo docker-compose up --build -d

sudo docker-compose logs -f
```

The flag `-d` stands for running it in background (detached mode).


To stop the container use this command with the --volume (-v) flag.
```bash
sudo docker-compose down -v
```




### Deploy on swarm

Start the Data-Stack using `docker stack` on a manager node:

If not already done, start a registry instance to make the cumstomized jupyter-image
deployable: (we are using port 5001, as logstash's default port is 5000)

```bash
sudo docker service create --name registry --publish published=5001,target=5000 registry:2
curl 127.0.0.1:5001/v2/
```
This should output {}:


Now register the customized images defined in the `docker-compose.yml`.
```bash
cd /swarm/dataStack
sudo docker-compose build
sudo docker-compose push
```


After that we can deploy the dataStack
```bash
sudo docker stack deploy --compose-file docker-compose.yml elk
```


Watch if everything worked fine with:
```bash
sudo docker service ls
sudo docker stack ps db-adapter
sudo docker service logs db-adapter_kafka -f
```



###  Services

Give Kibana a minute to initialize, then access the Kibana web UI by hitting
[http://localhost:5601](http://localhost:5601) with a web browser.
The indexing of elasticsearch could last 15 minutes or more, so we have to be patient.
On Kibana UI, DevTools we can trace the indexing success by hitting the REST request
`GET _cat/indices`.



By default, the stack exposes the following ports:
* 5000: Logstash TCP input
* 9200: Elasticsearch HTTP
* 9600: Logstash HTTP
* **5601: Kibana:** User Interface for data in Elasticsearch
* 3030: Kafka-DataStack Adapter HTTP: This one requires the db-adapter
* **8080: Swarm Visalizer:** Watch all services on the swarm
* **8888: Jupyter GUI:** Run Python and R notebooks with Spark support on elastic data



### Data Feeding

In order to feed the Data-Stack with data, we can use the
[Kafka-DataStack Adapter](https://github.com/i-maintenance/DB-Adapter).

The Kafka-Adapter automatically fetches data from the kafka message bus on
topic **SensorData**. The selected topics can be specified in
`.env` file of the Kafka-DataStack Adapter


To test the Data-Stack itself (without the kafka adapter), inject example log entries via TCP by:

```bash
$ nc hostname 5000 < /path/to/logfile.log
```



