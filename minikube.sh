#!/usr/bin/env sh
minikube start \
--cpus 4 \
--disk-size 30000 \
--kubernetes-version 1.17.3 \
--memory 12288 \
--vm-driver hyperkit \
--network-plugin=cni \
--extra-config=kubelet.network-plugin=cni
