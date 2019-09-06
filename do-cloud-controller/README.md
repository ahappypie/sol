# DigitalOcean Cloud Controller Manager (DO-CCM)
The [DigitalOcean Cloud Controller Manager](https://github.com/digitalocean/digitalocean-cloud-controller-manager) is responsible for turning annotations into DigitalOcean API requests. Specifically, this CCM controls LoadBalancer-type Service annotations (turning them into DO Load Balancers) and Block Storage-type storage class annotations (turning them into DO Block Storage Volumes). This deployment only relies on the CCM's load balancer functionality.

As noted on the [project readme](https://github.com/digitalocean/digitalocean-cloud-controller-manager), this CCM follows the DOKS managed product. So, if the managed product is at upstream Kubernetes v1.14.x, then the official CCM image will only support up to Kubernetes API v1.14.x. Since Kubernetes updates more frequently than the official CCM release, it is occasionally necessary to build the CCM from the development branch, push it to your own repository, and deploy from there. The manually-built images for this deployment live at [quay.io](https://quay.io/repository/ahappypie/digitalocean-cloud-controller-manager).

### Prerequisites
* A properly-bootstrapped cluster. See the [documentation](https://github.com/digitalocean/digitalocean-cloud-controller-manager) for an explanation, and this deployment's `terraform` as an example.
* A DO Personal Access Token

### Customizing Manifests
* Add your Personal Access Token to `secret.yaml`.
* *(Optional)* Ensure the CCM is compatible with your Kubernetes API verison by building it yourself.
* Make sure to change in the image tag in `deployment.yaml` to reflect the appropriate CCM image.

### Applying Manifests
* **DO NOT apply these manifests**. This is handled by the Terraform provisioner.

## Looking for Help
I'm not sure what can be done to ease this process, but if you are using the CCM, I'm sure the DO team would like to see any issues or pull requests in the [repository](https://github.com/digitalocean/digitalocean-cloud-controller-manager).

I am also very excited to see what the future holds with the Kubernetes [Cluster API](https://github.com/kubernetes-sigs/cluster-api), which may replace the CCM concept (or at least decouple it from the Kubernetes API).
