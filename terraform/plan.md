# Plan

0. Create firewalls (might have to force tags first. Maybe via DO API?)
  * ssh-target
    * TCP 22 - ssh inbound from `$my_ip`
  * k8s-node
    * TCP 10250 - kubelet inbound from other nodes
  * k8s-master
    * TCP 6443 - API server inbound from other nodes and `$my_ip`
    * TCP 2379-2380 - etcd inbound from other nodes
    * TCP 10251 - scheduler inbound from other nodes
    * TCP 10252 - controller-manager inbound from other nodes
  * weave-net
    * TCP 6783 inbound from other nodes
    * UDP 6783/6784 inbound from other nodes
1. Boot master node
  * Use cloud-init to bootstrap docker/kubernetes binaries
  * Use tags to attach firewalls - ssh-target, k8s-node, k8s-master, weave-net
  * Remote-exec `master-init.sh`
  * Copy `/var/kubeadm/join.sh` and `/etc/kubernetes/admin.conf` to `./kube`
  * ~Remote-exec `weave-net.sh`~ now part of `master-init.sh`
2. Boot worker nodes
  * cloud-init bootstraps binaries
  * Use tags to attach firewalls - ssh-target, k8s-node, weave-net
  * Remote-exec uses `join.sh` to join master node
