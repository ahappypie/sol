#!/usr/bin/env bash
echo $(kubectl -n logging get secret elasticsearch-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
