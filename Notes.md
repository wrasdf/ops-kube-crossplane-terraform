### Steps 
- ./bin/setup.sh
- ./bin/compile.sh alpha-apse2-v1
- kubectl apply -f ./_build/alpha-apse2-v1/002-system/
- kubectl apply -f ./_build/alpha-apse2-v1/compositions/dynamodb/composition.yaml
- kubectl apply -f ./_build/alpha-apse2-v1/compositions/dynamodb/definition.yaml
- kubectl apply -f ./_build/alpha-apse2-v1/compositions/s3/composition.yaml
- kubectl apply -f ./_build/alpha-apse2-v1/compositions/s3/definition.yaml

### Examples
- kubectl apply -f ./_build/alpha-apse2-v1/workspaces/dynamodb/workspace.yaml
- kubectl apply -f ./_build/alpha-apse2-v1/workspaces/s3/workspace.yaml
- kubectl apply -f ./_build/alpha-apse2-v1/compositions/dynamodb/dynamodb.yaml
- kubectl apply -f ./_build/alpha-apse2-v1/compositions/s3/s3.yaml

### Delete CustomResourceDefinition
- k edit CustomResourceDefinition providerconfigs.tf.upbound.io 
  - remove `finalizers`
- k delete CustomResourceDefinition providerconfigs.tf.upbound.io

### Others
- k get provider.pkg.crossplane.io
- k get providerconfig.tf.upbound.io
