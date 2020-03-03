#!/usr/bin/env sh
helm upgrade \
--install \
--namespace=logging \
--cleanup-on-fail \
-f config.yaml \
loki loki/
