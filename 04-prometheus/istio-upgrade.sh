#!/usr/bin/env sh
helm upgrade \
--install \
--namespace=monitoring \
--cleanup-on-fail \
-f istio-config.yaml \
prometheus prometheus/
