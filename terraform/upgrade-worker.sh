#!/usr/bin/env bash
#on client
NODE=${1?Error: no node given}
kubectl drain $NODE --ignore-daemonsets --delete-local-data
#on node
apt-mark unhold kubelet kubeadm
apt-get update && apt-get upgrade -y kubelet kubeadm
apt-mark hold kubelet kubeadm
kubeadm upgrade node config --kubelet-version $(kubelet --version | cut -d ' ' -f 2)
systemctl restart kubelet
systemctl status kubelet
#on client
kubectl uncordon $NODE
