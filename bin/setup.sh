#!/usr/bin/env bash

set -euo pipefail


### install crossplane

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane \
  --namespace crossplane-system \
  --create-namespace \
  crossplane-stable/crossplane \
  --version 1.11.3

### setup ProviderConfig 

### Setup private git credentials
# cat .git-credentials
# https://<user>:<token>@github.com

# kubectl -n crossplane-system create secret generic git-credentials --from-file=.git-credentials

### setup aws-creds ?
# Do we need to do this?

