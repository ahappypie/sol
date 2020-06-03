## Install steps
* `kubectl apply -f 00-common.yaml`
* `kubectl apply -f 01-operator.yaml`
* Wait for operator and discover pods to be `RUNNING`
* `kubectl apply -f 02-cluster.yaml`
* Wait for pods to stabilize (typically `rook-ceph-osd-prepare` > `Completed`)
* `kubectl apply -f 03-toolbox.yaml`
* `./04-toolbox.sh` health should be `ok` or `warn` that there is only one osd or there are no replicas configured
* `kubectl apply -f 05-storage-class.yaml`

## Note about stability
As of *first* writing (Rook v1.2.5), I have experienced significant stability issues during install on `minikube`. In particular, the `mgr` pod occasionally refuses to come up, and if you `kubectl delete` the cluster manifest the VM tends to crash. These issues were not present at all during the time I ran Rook in production across multiple nodes, so I'm chalking it up to minikube, hyperkit and the single node environment. Feel free to file an issue or PR if something changes.

Update (2020-06-02): After migrating to Rook v1.3.4 and switching to KVM-based minikube and attaching a virtual disk (see `../minikube.sh`), stability appears to be much better.

## Ceph Dashboard Access Note
Until [this issue](https://github.com/rook/rook/issues/2492) is resolved, you must run [05-dashboard-external.sh]('./05-dashboard-external.sh') to be able to use `kubectl port-forward` to access the Ceph Dashboard.
