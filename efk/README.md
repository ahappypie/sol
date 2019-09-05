# Rook
The venerated [ElasticSearch](https://www.elastic.co/products/elasticsearch)-[Fluentd](https://www.fluentd.org)-[Kibana](https://www.elastic.co/products/kibana) stack, from Elastic and Treasure Data. ElasticSearch and Kibana are built for indexing and exploring unstructured data, and Fluentd (deployed as the high-performance FluentBit) forwards logs from workloads to ElasticSearch.

### Prerequisites
* None

### Customizing Manifests
* `00-eck-operator.yaml`: Mostly boilerplate for the operator. Make sure to check the StatefulSet (line 1173) for the correct version.
* `01-logging-namespace.yaml`: Sets up namespace for tool deployment.
* `02-es.yaml`: Definition for `elasticsearch` cluster. This deployment separates master and data/ingest nodes, and deploys 3 of each. This can be split again, for isolated data and ingest, scaled up or down, or re-combined into a single node for master, data and ingest. This also provisions Rook storage, so deploy Rook first or change the storage class.
* `03-kibana.yaml`: Definition for `kibana` instance that connects to above `elasticsearch` cluster. So far the experience has been rather rocky, so deploy this with care.
* `04-fluentbit-rbac.yaml`: Service accounts and role bindings for `fluentbit`. No customization needed.
* `05-fluentbit-es-configmap.yaml`: `fluentbit` ConfigMap. If you need to add additional parsers, this is the place to do it. Also, if `fluentbit` complains about not being able to connect to `elasticsearch`, it's probably something to do with the `tls` settings.
* `06-fluentbit.yaml`: `fluentbit` DaemonSet. If you changed your `elasticsearch` user or certificate configuration, make sure to modify the environment variables and volume mounts appropriately.

### Applying Manifests and Accessing Services
* Apply manifests in order. You may need to wait briefly for the operator and ElasticSearch to come up.
* Port forward Kibana to your local machine with `port-forward.sh`.
* Grab the default password using `elastic-password.sh`.
* Make sure to set up index rollover so you don't overflow your PersistentVolumeClaim.

## Looking for Help
I'm sure there are additional customizations that could be baked in here by default. Feel free to suggest them!

The Elastic Operator hasn't been particularly stable during development, and the version deployed in this cluster (v0.8.1) was the latest stable release I could find (despite newer versions existing at the time). I would like to continue tracking the operator's development, but if anyone has a more stable deployment, please submit a pull request so we can compare!
