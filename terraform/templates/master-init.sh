#!/usr/bin/env bash
kubeadm config images pull

mkdir -p /var/kubeadm

kubeadm init --config=/var/kubeadm/do-ccm-master.yaml > /var/kubeadm/kubeadm.out

export KUBECONFIG=/etc/kubernetes/admin.conf

cat /var/kubeadm/kubeadm.out | tail -2 > /var/kubeadm/join.sh

openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //' > /var/kubeadm/discovery-token-hash
kubeadm token list | tail -1 | sed 's/\s.*//' > /var/kubeadm/auth-token

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.32.0.0/16"
kubectl apply -f /var/kubeadm/do-cloud-controller
