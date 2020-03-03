#!/usr/bin/env sh
helm upgrade \
--install \
--namespace=grafana \
--cleanup-on-fail \
-f config.yaml \
grafana grafana/
