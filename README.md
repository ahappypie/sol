# Sol

## Project Status
Sol is currently under heavy development. The primary development hardware is a bare metal, single node `kubeadm` bootstrapped cluster. The following tools have been successfully deployed:
* Kubernetes: v1.13.3
* etcd: v3.2.24
* CoreDNS: v1.2.6
* WeaveNet: v2.5.1
* Rook: v0.9.3 (Ceph v13.2.4-20190109)

### Goals
Sol aims to present basic configuration for a Kubernetes reference architecture, using cloud native tools to form the backbone of any new cluster. In short, **Sol is a platform**.

### Core Tools
+ [etcd](https://etcd.io) - CoreOS etcd is a key value store, used to provide a backing store for Kubernetes clusters.
+ [WeaveNet](https://weave.works/oss/net) - WeaveNet (from WeaveWorks) is an overlay network that forms a mesh, in the case of Kubernetes, for the pod network. It supports multicast and can bypass the overlay on certain providers.
+ [Rook](https://rook.io) - Rook is a storage orchestrator built from the ground up for Kubernetes. It provisions the excellent [Ceph](https://ceph.com) block storage system, and has alpha support for additional cloud-native storage systems like [Minio](https://minio.io) (S3-compatible object storage) and [EdgeFS](https://edgefs.io) (geo-transparent storage), along with controllers for databases like [CockroachDB](https://cockroachlabs.com) and [Apache Cassandra](https://cassandra.apache.org) and even the ability to deploy a good, old-fashioned NFS.
+ [Istio](https://istio.io) - Built on Lyft's [Envoy](https://envoyproxy.io) proxy, Istio manages a series of tools to create a service mesh and manage ingress and egress in Kubernetes. Istio has first-class support for [GRPC](https://grpc.io) and also integrates with metrics and tracing tools.
+ [Prometheus](https://prometheus.io) - Built by Soundcloud and based on Google's Borgmon, Prometheus is a metrics and alerting tool that uses a wide array of integrations. It collects time series data from every level of the stack - hardware, Kubernetes itself and your applications.
+ [ElasticSearch](https://elastic.co/products/elasticsearch)/[Fluentd](https://fluent.org)/[Kibana](https://elastic.co/products/kibana) - The venerable "EFK" stack, using Fluentd-based FluentBit as a forwarding service, with ElasticSearch for indexing and search, and Kibana for visualization. As a bonus, ElasticSearch can be reused by any number of applications looking for an indexing and search service.
+ [Jaeger](https://jaegertracing.io) - [OpenTracing](https://opentracing.io)-compatible tracing system originally built by Uber. Jaeger and OpenTracing trace calls within your applications and integrate with Istio to trace calls within your service mesh. Spans can be stored in ElasticSearch, which means you don't have to deploy yet another tool.

### Additional tools
+ [NATS](https://nats.io) - Lightweight message queue written in Go. NATS uses the Raft consensus algorithm to avoid heavy external coordinators like ZooKeeper. It also has a streaming layer than can be deployed on top of an existing NATS cluster to provide durable delivery.

### More reading
All of these tools were chosen in part because they have significant community backing. Check out the respective projects here on Github. If there's another tool you're looking for, chances are it's listed on the Cloud Native Computing Foundation's [Landscape](https://github.com/cncf/landscape).
