#!/usr/bin/env bash
kubectl -n rook-ceph exec -it $(kubectl -n rook-ceph get pod -l "app=rook-ceph-tools" -o jsonpath='{.items[0].metadata.name}') -- ceph config set mgr mgr/dashboard/server_addr 0.0.0.0

kubectl delete pod -n rook-ceph  $(kubectl -n rook-ceph get pod -l "app=rook-ceph-mgr" -o jsonpath='{.items[0].metadata.name}')
