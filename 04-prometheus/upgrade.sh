#!/usr/bin/env sh
helm upgrade \
--install \
--namespace=monitoring \
--cleanup-on-fail \
-f config.yaml \
prometheus prometheus/
