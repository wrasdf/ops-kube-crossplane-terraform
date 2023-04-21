#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo
  echo "usage: ./bin/setup.sh <cluster>"
  echo "  ie. ./bin/setup.sh alpha-apse2-v1"
  exit 255
fi

cluster=${1}

### install crossplane
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm template crossplane \
  --namespace upbound-system \
  --create-namespace \
  crossplane-stable/crossplane \
  --version 1.11.3 > ./crossplane-terraform/templates/system/crossplane.yaml

./bin/compile.sh $cluster

stackup "ops-kube-crossplane-terraform-privider-$cluster" up -t "_build/$cluster/cfn/template.yaml"

