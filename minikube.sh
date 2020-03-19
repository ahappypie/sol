#!/usr/bin/env sh
minikube start \
--cpus 4 \
--disk-size 30000 \
--kubernetes-version 1.17.4 \
--memory 16384 \
--driver hyperkit \
--network-plugin=cni \
--extra-config=kubelet.network-plugin=cni
