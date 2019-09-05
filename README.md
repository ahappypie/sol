# Sol

## Project Status
Sol is currently under heavy development. While the primary development hardware was a bare metal, single node `kubeadm` bootstrapped cluster, this branch tracks a terraform bootstrapped DigitalOcean cluster. This deployment has been in production at Regent LP since July 2019. The current tools managed are:
* Kubernetes v1.15.1
* etcd v3.3.10
* CoreDNS v1.3.1
* WeaveNet v2.5.2
* Ambassador v0.73.0
* Rook v1.0.4
  * Ceph v14.2.1-20190430
* kube-prometheus v0.30.0
  * Prometheus v2.7.2
  * Grafana v6.0.1
  * Alertmanager v0.17.0
  * node-exporter v0.17.0
* eck-operator v0.8.1
  * ElasticSearch v7.1.0
  * Kibana v7.1.0
* Fluent Bit v1.2.1
* DigitalOcean Cloud Controller v0.1.15 (commit 8cc7ee3)

### Notes
The tools above were deployed with minimal configuration. Basically, what's in the YAML is what's running in the cluster. No runtime hacks or ConfigMap patches. That probably means you can't just `kubectl apply -f .`. The goal is to turn the installation of these tools into a simple shell command, but it's not quite there yet. However, if you like the idea, feel free to get in contact or submit a pull request.

***A special note about the DigitalOcean Cloud Controller:*** The controller (aka CCM) is responsible for turning LoadBalancer-type Service annotations and DigitalOcean Block Storage-type StorageClass annotations into appropriate DigitalOcean-managed resources (Load Balancers and Block Storage volumes, respectively). Because of the way CCMs are built, they require the matching Kubernetes API as a dependency. At the time of deployment, the DigitalOcean team had not yet released full support for Kubernetes v1.15.x, but the CCM's development branch was stable enough to build manually and deploy. This image lives at [quay.io](https://quay.io/repository/ahappypie/digitalocean-cloud-controller-manager), not the official DigitalOcean repository. This branch is likely to switch to the official build soon.
