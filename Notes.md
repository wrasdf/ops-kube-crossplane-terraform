### Steps 
- ./bin/setup.sh
- kubectl apply -f ./_build/alpha-apse2-v1/system/
- kubectl apply -f ./_build/alpha-apse2-v1/compositions/dynamodb/
- kubectl apply -f ./_build/alpha-apse2-v1/compositions/s3/
- kubectl apply -f ./_build/alpha-apse2-v1/workspaces/dynamodb/workspace.yaml
- kubectl apply -f ./_build/alpha-apse2-v1/workspaces/s3/workspace.yaml

### Others
- k get provider.pkg.crossplane.io
- k get providerconfig.tf.upbound.io
- k edit CustomResourceDefinition providerconfigs.tf.upbound.io 
  - remove `finalizers`

- k delete CustomResourceDefinition providerconfigs.tf.upbound.io
