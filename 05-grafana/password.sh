#!/usr/bin/env sh
kubectl -n grafana get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode | pbcopy
