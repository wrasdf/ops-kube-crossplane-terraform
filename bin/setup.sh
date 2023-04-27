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
  crossplane-stable/crossplane \
  --version 1.11.3 > ./crossplane-terraform/templates/002-system/001-crossplane.yaml

./bin/compile.sh $cluster

stackup "ops-kube-crossplane-terraform-privider-$cluster" up -t "_build/$cluster/001-cfn/template.yaml"

