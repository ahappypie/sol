#!/usr/bin/env bash
kubectl -n logging port-forward svc/kibana 5601
