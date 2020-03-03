#!/usr/bin/env sh
minikube start --network-plugin=cni --extra-config=kubelet.network-plugin=cni
