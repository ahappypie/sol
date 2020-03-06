#!/usr/bin/env sh
istioctl manifest generate \
--set profile=default \
--set values.prometheus.enabled=false \
> manifest.yaml

#removed due to https://github.com/istio/istio/issues/19719. Will try installing and configuring separately
#--set values.kiali.enabled=true --set values.kiali.createDemoSecret=true \
#--set unvalidatedValues.kiali.prometheusAddr="http://prometheus-server.monitoring.svc.cluster.local:80" \
