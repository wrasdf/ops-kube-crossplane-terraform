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
  echo "=== preparing $cluster template ==="
  rm -rf _build
  mkdir -p _build/${cluster}
}

function castTemplate() {

  echo "=== casting $cluster crossplane system config templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/system \
    --output-dir=_build/${cluster}/system \
    --context config=${configfile}

  echo "=== casting $cluster crossplane IAM CFN templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/cfn \
    --output-dir=_build/${cluster}/cfn \
    --context config=${configfile}

  echo "=== casting $cluster dynamodb workspace templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/dynamodb \
    --output-dir=_build/${cluster}/workspaces/dynamodb \
    --context config=${configfile}

  echo "=== casting $cluster s3 workspace templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/s3 \
    --output-dir=_build/${cluster}/workspaces/s3 \
    --context config=${configfile}  

  echo "=== casting $cluster compositions s3 templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/compositions/s3 \
    --output-dir=_build/${cluster}/compositions/s3 \
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

