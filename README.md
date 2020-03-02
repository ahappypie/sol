# Sol - Extensions and Proposals
The goal of this branch is to explore potential extensions on top of Sol deployments.

Also to name things. For instance, this project is called Sol instead of Helios because the Roman gods built on top of the Greek gods, just like this builds on top of Kubernetes, which is Greek for helmsman or pilot (of a ship). I've decided to name these extensions after the Roman gods they (somewhat) represent, and clusters themselves have been named for the planets, starting with dwarf planet Ceres (the original test cluster), then Mercury (Regent LP's current production cluster). The bigger the cluster, the bigger the planet. I'm hoping to save the gas giants for clusters with multiple node types that can be named after their respective moons.

### Core Tools
For reference, the core tools deployed are:
+ [etcd](https://etcd.io)
+ [WeaveNet](https://weave.works/oss/net)
+ [Rook](https://rook.io)
+ [Istio](https://istio.io)
+ [Prometheus](https://prometheus.io)
+ [ElasticSearch](https://elastic.co/products/elasticsearch)/[Fluentd (*as Fluentbit*)](https://fluent.org)/[Kibana](https://elastic.co/products/kibana)
+ [Jaeger](https://jaegertracing.io)

### Proposal: Fully integrated continuous integration/continuous deployment
aka **VULCAN**, god of the forge

There is currently a large movement to build Kubernetes-native CI/CD tooling, mostly in the form of the [Tekton](https://tekton.dev) and [Jenkins X](https://jenkins-x.io) projects, but these tools are still under heavy development and will probably lack features for a long time.

However, there is plenty of maturity around the original [Jenkins](https://jenkins.io) project, as well as the GitOps workflow. These tools can all be deployed to Kubernetes and extend the functionality provided by the core deployment to provide a complete and mature workflow:

+ [Jenkins](https://jenkins.io) - Jenkins is traditionally deployed as a master/static agent cluster, but there is a [plugin](https://plugins.jenkins.io/kubernetes) for launching Jenkins agents dynamically in Kubernetes Pods. Rancher has a [good write up](https://rancher.com/blog/2018/2018-11-27-scaling-jenkins/) on how to get it working. Jenkins storage can be deployed as Rook-managed Ceph Block Storage volumes. My immediate concern is that you have to manage build container images (with your dependencies for the build, so one with node.js, one with the JDK, one with golang, etc.), and if you are building containers within containers, that raises issues around mounting host resources into a container with elevated privileges, which leads to the next tool...
+ [img](https://github.com/genuinetools/img) - like it says on the box, `img` builds container images without using the docker daemon, so it has no need for elevated privileges. There are some other tools in the space, including Google's [kaniko](https://github.com/GoogleContainerTools/kaniko), but `img` seems to be the simplest. Also, here's a [nice write up](https://prabhatsharma.in/blog/how-to-build-docker-images-in-kubernetes-with-jenkins-without-privileges-using-img/) integrating Jenkins and `img`, and pushing the resulting image to AWS Elastic Container Registry.
+ [Harbor](https://goharbor.io) - image (and chart, if you're into that) registry. Bundles Notary and Clair for image signing and security scanning. Kubernetes-ready Helm chart available [here](https://github.com/goharbor/harbor-helm), can extend Istio for ingress and Rook for storage.
+ [flux](https://fluxcd.io) - automated deployment tool from WeaveWorks. To quote the Flux documentation directly:
> Flux monitors all of the container image repositories that you specify. It detects new images, triggers deployments, and automatically updates the desired running configuration of your Kubernetes cluster

  Point it at Harbor. Easy win.
+ [flagger](https://github.com/weaveworks/flagger) - WeaveWorks companion to `flux` that enables fancy deployments like A/B and canary. Uses Prometheus to check metrics and Istio to route traffic during tests.

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
