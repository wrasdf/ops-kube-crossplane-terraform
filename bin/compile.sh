#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo
  echo "usage: ./bin/compile.sh <cluster>"
  echo "  ie. ./bin/compile.sh alpha-apse2-v1"
  exit 255
fi

cluster=${1}
configfile=clusters/${cluster}.yaml

function cleanTemplate() {
  echo "=== prepare $cluster template ==="
  rm -rf _build
  mkdir -p _build/${cluster}
}

function castTemplate() {

  echo "=== casting $cluster crossplane IAM CFN templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/001-cfn \
    --output-dir=_build/${cluster}/001-cfn \
    --context config=${configfile}
    
  echo "=== casting $cluster crossplane system config templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/002-system \
    --output-dir=_build/${cluster}/002-system \
    --context config=${configfile}

  echo "=== casting $cluster workspace dynamodb templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/workspaces/dynamodb \
    --output-dir=_build/${cluster}/workspaces/dynamodb \
    --context config=${configfile}

  echo "=== casting $cluster workspace s3 templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/workspaces/s3 \
    --output-dir=_build/${cluster}/workspaces/s3 \
    --context config=${configfile}  

  echo "=== casting $cluster compositions s3 templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/compositions/s3 \
    --output-dir=_build/${cluster}/compositions/s3 \
    --context config=${configfile}    

  echo "=== casting $cluster compositions dynamodb templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/compositions/dynamodb \
    --output-dir=_build/${cluster}/compositions/dynamodb \
    --context config=${configfile}    

}

if [[ ! -f "${configfile}" ]]
then
  echo "error: configfile does not exist: ${configfile}"
  exit 1
fi

cleanTemplate
castTemplate

echo "Done!"

