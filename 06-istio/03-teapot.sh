#!/usr/bin/env sh
curl $(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath="{.status.loadBalancer.ingress[0].ip}")/status/418 -Hhost:httpbin.org
