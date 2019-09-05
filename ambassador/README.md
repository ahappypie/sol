# Ambassador
Ambassador is a management layer on top of Lyft's [Envoy](https://envoyproxy.io) reverse proxy, built by Datawire. It is deployed here to direct traffic from a DigitalOcean Load Balancer. These manifests also include Jetstack's CertManager, which automatically provisions and rotates SSL for your domain. This deployment's domain is registered in AWS Route53.

### Prerequisites
* An AWS Route53 domain
* AWS API keys with access to your Route53 details (see `route53-iam-policy.json` for an example)

### Customizing Manifests
* `00-certmanager.yaml`: `cert-manager` prerequisites. Shouldn't be any need to touch this file, unless you want to change the namespace (default: `cert-manager`)
* `01-aws-secret.yaml`: Fill in your AWS key details. You will want to `base64` encode the keys first.
* `02-ambassador-rbac.yaml`: `ambassador` prerequisites. Shouldn't be any need to touch this file.
* `03-ambassador.yaml`: `ambassador` DaemonSet. The traditional Ambassador is a Deployment, but because of the way the DigitalOcean Load Balancer does health checks, you will need one Ambassador pod per node. It will label itself unhealthy if it cannot reach the droplet. Looking forward to more robust health check options in the future, but this works for now.
* `04-clusterissuer.yaml`: declaration to tell `cert-manager` what you are looking for. Fill in the email you want to be notified about certificate expiration (though cert-manager will auto-rotate before expiration), as well as your AWS keys. The accessKeyID should be in plain text (unfortunately). Looking forward to a way to grab that from the secret as well.
* `05-certificate.yaml`: declaration to tell `cert-manager` what the certificate is for and where to put it. Fill in your domain information.
* `06-ambassador-service.yaml`: `ambassador` service annotation. Configure Ambassador and the DigitalOcean Load Balancer here. For DO options, see the [CCM documentation](https://github.com/digitalocean/digitalocean-cloud-controller-manager/blob/master/docs/controllers/services/annotations.md).
* `07-prometheus-monitoring.yaml`: return to this manifest once Prometheus is running to add Ambassador metrics to your dataset.

### Applying Manifests
* You should run one manifest at a time, in order. You will need to wait for some workloads to complete before continuing, specifically, wait for the `cert-manager` namespace to become populated, the certficate to be issued, and the `ambassador` DaemonSet to come online.
* `y-httpecho.yaml` and `z-httpbin.yaml` can be used to verify this setup.

## Looking for Help
I'm sure there are additional customizations that could be baked in here by default. Feel free to suggest them!

There is quite a bit of work to be done around Ambassador health checks and DigitalOcean Load Balancers. It works for now, but DO is only doing a static TCP check on a single port per node. Eventually I'd like to see this target the actual health check path defined in the manifest. I have seen some issues and PRs around this for other combinations of tools, so if you want to take a look, pull requests are always welcome.
