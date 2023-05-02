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

### patchSet in Composition
```
spec:
  patchSets:
    patches:
      - fromFieldPath: metadata.name
        toFieldPath: spec.writeConnectionSecretToRef.name
      - fromFieldPath: metadata.namespace
        toFieldPath: spec.writeConnectionSecretToRef.namespace
  ...      
  resources:
    - name: terraform-dynamodb
      patches:
        - type: PatchSet
          patchSetName: common
        - fromFieldPath: spec.bucket_name
          toFieldPath: spec.forProvider.vars[0].value
```

### Errors

- When I kill the `crossplane-provider-terraform-*` pod, got error from pod.
```
Error: Error acquiring the state lock

Error message: the state is already locked by another terraform client
Lock Info:
  ID:        f9cab9bd-4ce9-08cb-dbb1-4090791b09f0
  Path:
  Operation: OperationTypeApply
  Who:       @crossplane-provider-terraform-fbc1e6f37348-557b86567c-z9ttf
  Version:   1.3.7
  Created:   2023-04-27 02:01:04.034685666 +0000 UTC
  Info:


Terraform acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.
```
  - `I don't know which terraform resources got this error`
