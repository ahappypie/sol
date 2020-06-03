#!/usr/bin/env sh
export DRIVER="hyperkit"

if [ $(uname) = "Linux" ]
  then
    export DRIVER="kvm2"
fi

minikube start \
--cpus 6 \
--disk-size 20000 \
--kubernetes-version 1.18.3 \
--memory 24576 \
--driver ${DRIVER} \
--network-plugin=cni \
--extra-config=kubelet.network-plugin=cni

if [ $(uname) = "Linux" ]
  then
    qemu-img create -f raw minikube-rook-data-30G 30G
    virsh -c qemu:///system attach-disk minikube $(pwd)/minikube-rook-data-30G vdb --cache none --persistent
fi

minikube stop && minikube start
