#!/usr/bin/env sh
kubectl get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode | pbcopy
