### Core Tools
For reference, the core tools deployed are:
+ [etcd](https://etcd.io)
+ [WeaveNet](https://weave.works/oss/net)
+ [Rook](https://rook.io)
+ [Istio](https://istio.io)
+ [Prometheus](https://prometheus.io)
+ [ElasticSearch](https://elastic.co/products/elasticsearch)/[Fluentd](https://fluent.org)/[Kibana](https://elastic.co/products/kibana)
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
