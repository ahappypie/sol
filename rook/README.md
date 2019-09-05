# Rook
[Rook](https://rook.io) is a cloud-native storage orchestrator. It abstracts away the complexity of provider-specific storage APIs and provides a single, declarative method of attaching storage to workloads.

### Prerequisites
* A FlexVolumePlugin-enabled cluster. For example, the managed DOKS product appears to deploy itself in such a way that blocks the FlexVolumePlugin. `kubeadm` enables the plugin by default.

### Customizing Manifests
* `00-common.yaml`: `rook` common components. No customization needed.
* `01-operator.yaml`: `rook` operator definition. No customization needed.
* `02-cluster.yaml`: `ceph` storage cluster configuration. Things to definitely check:
  * Line 23: `ceph` image version. As the comment notes, be very specific about what you want `rook` to deploy.
  * Line 30: `mon` configuration. Change this depending on how many (storage) nodes in your cluster. By default, this deployment has 5 nodes, all of which can be storage nodes.
  * Line 92: storage configuration. This is the true power of `rook`. Declare the node/device patterns you want `rook` to manage. This deployment manages the `vda` disk attached (by default) to all droplets in this cluster. You could easily attach additional devices (`vdb`, etc.), modify this configuration, and `rook` would automatically begin managing storage on those devices.
* `03-block.yaml`: StorageClass to identify the `ceph` block pool by. Use this in your PersistentVolumeClaims to add storage to your pods. Tons of configuration options (especially replication control) in the [documentation](https://rook.io/docs/rook/v1.0/ceph-pool-crd.html).
* `04-filesystem.yaml`: StorageClass to identify `ceph` file store. Not used in this deployment, but included for reference.
* `05-toolbox.yaml`: Deploys the `ceph` toolbox. Helpful for debugging.
* `06-dashboard-external.sh`: Used as a workaround for a long-standing issue in `rook`. No longer necessary, but included for reference.
* `07-service-monitor.yaml`: Exposes metrics to Prometheus.

### Applying Manifests
* Apply manifests in order. You may need to wait briefly for the operator and storage cluster to come up.
* Test the deployment by attempting to bind a small PersistentVolumeClaim.

## Looking for Help
I'm sure there are additional customizations that could be baked in here by default. Feel free to suggest them!

Rook also supports the [Container Storage Interface](https://kubernetes-csi.github.io/docs/), though it hasn't been around as long as this approach. If you have been using Ceph CSI in production, I'd love to see a pull request with that configuration alongside this one!
