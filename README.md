### Core Tools
For reference, the core tools deployed are:
+ [etcd](https://etcd.io)
+ [WeaveNet](https://weave.works/oss/net)
+ [Rook](https://rook.io)
+ [Istio](https://istio.io)
+ [Prometheus](https://prometheus.io)
+ [ElasticSearch](https://elastic.co/products/elasticsearch)/[Fluentd (*as Fluentbit*)](https://fluent.org)/[Kibana](https://elastic.co/products/kibana)
+ [Jaeger](https://jaegertracing.io)

### Proposal: Gen 3 Data Platform
aka **MINERVA**, goddess of wisdom

At the core of 3rd generation data platforms is the intersection of schema and near-real time data. Most platforms evolved out of necessity and were based in the Hadoop Ecosystem with batch computing and loose (if any) JSON-based schema. While many of those tools and frameworks are still relevant, cloud-based object storage has replaced HDFS as the data lake of choice and managing schema changes at scale is untenable. This platform is based in part on Uber's platform as explained [here](https://eng.uber.com/uber-big-data-platform/).

+ [Kafka](https://kafka.apache.org) - industry standard distributed streaming processor. Unfortunately has a dependency on [Zookeeper](https://zookeeper.apache.org), but storage can be provided by Rook block volumes. There are multiple operators, including [Strimzi](https://strimzi.io/) and [Banzai Cloud](https://github.com/banzaicloud/kafka-operator). Confluent, the commercial support entity, also provides an operator.
+ [Schema Registry](https://docs.confluent.io/current/schema-registry/index.html) - [Avro](https://avro.apache.org) schema registry. Built by Confluent, this tool registers Avro (think of it as structure-over-JSON) schemas in specialized Kafka topics for the keys and values of each record. Allows for backwards (and forwards) compatible schema evolution, and ensures schema changes made on the producer side (i.e. your application) automatically propagate to your data platform.
+ [Spark](https://spark.apache.org) - industry standard distributed compute framework. Pluggable resource managers allow deployment in several environments, including Kubernetes...eventually. Google Cloud has an operator in [beta](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator). Used here for both ETL and ad-hoc analysis.
+ [Hudi](https://hudi.apache.org) - Spark library for **H**adoop **U**pserts **D**eletes and **I**ncremental, originally built at Uber to manage ETL for late-arriving data. Works by managing Avro and Parquet files in object storage, originally HDFS, but now S3 and S3-compatible stores in either copy-on-write or merge-on-read modes.
+ [Minio](https://minio.io) - open source S3-compatible object store. Runs in distributed mode on Kubernetes, backed by Rook block volumes or deployed by the Rook operator itself.
+ [Hive Metastore](https://hive.apache.org) - part of the Hive data warehouse, the metastore is responsible for holding schema information about objects in storage, in this case, Minio. Thanks to Hudi's support library and sync tool, writes from Spark to S3 can also update the Hive schema with any changes. Needs a relational database to persist schema information, like [MariaDB](https://mariadb.org) or [Postgres](https://postgresql.org), which can store on Rook.
+ [Presto](https://prestosql.io) - built by Facebook as they outgrew Hive, Presto is a distributed SQL engine. Its notion of catalogs allows it to query across data sources. It can use the Hive metastore to structure queries over data in S3. There's a bit of controversy regarding the open source governance, with 2 different forks, the Facebook/Uber/Linux Foundation led PrestoDB, and PrestoSQL, linked here, which was founded by the original engineers. They are, at this point, more or less the same.
+ [Airflow](https://airflow.apache.org) - yet another industry standard, Airflow is a workflow orchestration engine which organizes work as directed acyclic graphs, or DAGs. After several years of development, Airflow's Kubernetes integrations are plugged in to every part of the engine. Requires a relational database as storage.
+ [Amundsen](https://github.com/lyft/amundsen) - Lyft's metadata discovery service. Ingests information from various points to construct a graph of your data (in either Neo4j or Apache Atlas). Allows anyone who needs to find data to discover the who, what, when, where and how of your datasets. has a Helm chart for reference in the repo.
