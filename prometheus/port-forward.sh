#!/usr/bin/env bash
kubectl -n prometheus port-forward svc/grafana 3000
kubectl -n prometheus port-forward svc/prometheus-k8s 9090
kubectl -n prometheus port-forward svc/alertmanager-main 9093
