# Sol

## Project Status
Sol is currently under heavy development. This branch (*master*) tracks Minikube-based development. The following tools have been successfully deployed (alternatively see the output of `images.sh` once running):
* minikube: v1.8.1
* kubernetes: v1.17.3
  * etcd: v3.4.3-0
  * CoreDNS: v1.6.5
* WeaveNet: v2.6.1
* ~Rook: v1.2.5~ *seriously unstable on minikube, will be falling back to hostPath volumes for now*
  * ~Ceph: v14.2.7-20200206~
* Prometheus: v2.16.0
  * kube-state-metrics: v1.9.5
  * AlertManager: v0.20.0
  * NodeExporter: v0.18.1
  * PushGateway: v1.0.1
* Promtail: v1.3.0
* Loki: v1.3.0
* Grafana: v6.6.2
* Istio: v1.4.6

*WARNING: this is a very heavy deployment for minikube. On macOS, using the hyperkit driver (from Docker Desktop) with 4 CPUs and 12 GB memory, the hyperkit VM regularly uses 2.5-3 full CPUs idle. If you are on a laptop, this will peg your fans and burn through your battery.*

**A version of Sol (called Mercury) went to production in July 2019!** Please see the [`digitalocean`](https://github.com/ahappypie/sol/tree/digitalocean) branch in this repository.

### Goals
Sol aims to present basic configuration for a Kubernetes reference architecture, using cloud native tools to form the backbone of any new cluster. In short, **Sol is a platform**.

### Core Tools
+ [WeaveNet](https://weave.works/oss/net) - WeaveNet (from WeaveWorks) is an overlay network that forms a mesh, in the case of Kubernetes, for the pod network. It supports multicast and can bypass the overlay on certain providers.
+ [Rook](https://rook.io) - Rook is a storage orchestrator built from the ground up for Kubernetes. It provisions the excellent [Ceph](https://ceph.com) block storage system, and has alpha support for additional cloud-native storage systems like [Minio](https://minio.io) (S3-compatible object storage) and [EdgeFS](https://edgefs.io) (geo-transparent storage), along with controllers for databases like [CockroachDB](https://cockroachlabs.com) and [Apache Cassandra](https://cassandra.apache.org) and even the ability to deploy a good, old-fashioned NFS.
+ [Istio](https://istio.io) - Built on Lyft's [Envoy](https://envoyproxy.io) proxy, Istio manages a series of tools to create a service mesh and manage ingress and egress in Kubernetes. Istio has first-class support for [GRPC](https://grpc.io) and also integrates with metrics and tracing tools.
+ [Prometheus](https://prometheus.io) - Built by Soundcloud and based on Google's Borgmon, Prometheus is a metrics and alerting tool that uses a wide array of integrations. It collects time series data from every level of the stack - hardware, Kubernetes itself and your applications.
+ ~[ElasticSearch](https://elastic.co/products/elasticsearch)/[Fluentd](https://fluent.org)/[Kibana](https://elastic.co/products/kibana) - The venerable "EFK" stack, using Fluentd-based FluentBit as a forwarding service, with ElasticSearch for indexing and search, and Kibana for visualization. As a bonus, ElasticSearch can be reused by any number of applications looking for an indexing and search service.~
+ [Loki](https://grafana.com/loki)/[Promtail](https://github.com/grafana/loki/tree/v1.3.0/docs/clients/promtail)/[Grafana](https://grafana.com/) - Prometheus-inspired logging infrastructure from Grafana Labs. Skips heavy indexing from the EFK stack for indexing only log metadata...which is typically what you're searching by.
+ [Jaeger](https://jaegertracing.io) - [OpenTracing](https://opentracing.io)-compatible tracing system originally built by Uber. Jaeger and OpenTracing trace calls within your applications and integrate with Istio to trace calls within your service mesh. Spans can be stored in ElasticSearch, which means you don't have to deploy yet another tool.

### More reading
All of these tools were chosen in part because they have significant community backing. Check out the respective projects here on Github. If there's another tool you're looking for, chances are it's listed on the Cloud Native Computing Foundation's [Landscape](https://github.com/cncf/landscape).
