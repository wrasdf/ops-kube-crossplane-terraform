#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo
  echo "usage: ./bin/compile.sh <cluster> <version>"
  echo "  ie. ./bin/compile.sh alpha-apse2-v1 v0.1.30"
  exit 255
fi

cluster=${1}
version=${2}
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

echo "=== casting $cluster composition config templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/composition \
    --output-dir=_build/${cluster}/composition \
    --context config=${configfile}


  echo "=== casting $cluster dynamodb config templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/dynamodb \
    --output-dir=_build/${cluster}/dynamodb \
    --context config=${configfile}

  echo "=== casting $cluster s3 config templates ==="
  gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./crossplane-terraform/templates/s3 \
    --output-dir=_build/${cluster}/s3 \
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

