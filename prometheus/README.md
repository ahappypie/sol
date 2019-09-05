# Prometheus
Prometheus, based on Google's Borgmon and originally written at SoundCloud, is a monitoring, metrics and alerting system made up of several components. This deployment is based on [kube-prometheus](https://github.com/coreos/kube-prometheus), a library created at CoreOS to simplify the deployment process.

### Prerequisites
* `jb` (aka `jsonnet-bundler`), the jsonnet package manager - `go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb`
* `gojsontoyaml`, for converting jsonnet's `json` output to `yaml` - `go get github.com/brancz/gojsontoyaml`
* `jb install`

### Customizing and Building Manifests
* First, check out the [official documentation](https://github.com/coreos/kube-prometheus)
* In this `prometheus-rook.jsonnet`, there are a few customizations:
  * Line 6:, PersistentVolumeClaim is imported
  * Line 10: `kubeadm` defaults are added
  * Line 13: Prometheus components are assigned to the `prometheus` namespace
  * Line 15: Prometheus is told which namespaces to monitor - **add additional namespaces here or Prometheus will not see your workloads!**
  * Line 25: Metrics are retained for 3 days. Higher retention means more storage, which leads to the next customization...
  * Lines 36, 40, 43: Configures Prometheus to use Rook for storage - **which means you should deploy Rook first, or change the storage class!**
* Once you finish your customization, run the included `build.sh` script. Generated manifests will end up in `/manifests`.

### Applying Manifests and Accessing Services
* From here, you can run `kubectl apply -f ./manifests/`
* `port-forward.sh` includes the necessary shell commands to forward Grafana, Prometheus and Alertmanager to your local machine.

## Looking for Help
I'm sure there are additional customizations that could be baked in here by default. Feel free to suggest them!

There is a not-insignificant amount of customization needed to expose the services via Ingress (Ambassador, in this case). If you have this customization already, a pull request would be welcome. I would also love to try Ingress-exposed and auth-enabled customization as well! Probably don't want to expose your internal metrics on a public endpoint...
