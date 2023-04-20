#!/usr/bin/env bash

set -euo pipefail


### install crossplane

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm template crossplane \
  --namespace upbound-system \
  --create-namespace \
  crossplane-stable/crossplane \
  --version 1.11.3 > ./crossplane-terraform/templates/system/crossplane.yaml

# ### Upbound Universal Crossplane (UXP)

# helm repo add upbound-stable https://charts.upbound.io/stable && helm repo update
# helm template uxp \
#   --namespace upbound-system \
#   upbound-stable/universal-crossplane \
#   --devel > ./crossplane-terraform/templates/system/upbound.yaml

### setup ProviderConfig 

### Setup private git credentials
# cat .git-credentials
# https://<user>:<token>@github.com

# kubectl -n upbound-system create secret generic git-credentials --from-file=.git-credentials

### setup aws-creds ?
# Do we need to do this?

stackup "ops-kube-crossplane-terraform-privider-alpha-apse2-v1" up -t "_build/alpha-apse2-v1/cfn/template.yaml"

