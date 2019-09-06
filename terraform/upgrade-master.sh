#!/usr/bin/env bash
VERSION=${1?Error: no version given}
export KUBECONFIG=/etc/kubernetes/admin.conf
apt-mark unhold kubeadm kubelet
apt-get update && apt-get upgrade -y kubeadm kubelet
kubeadm upgrade plan
kubeadm upgrade apply $VERSION
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.32.0.0/16"
