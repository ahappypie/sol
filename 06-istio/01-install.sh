#!/usr/bin/env sh
istioctl manifest apply -f manifest.yaml
istioctl verify-install -f manifest.yaml
