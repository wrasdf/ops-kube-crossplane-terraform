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


- When I try to manually delete a dynamodb from AWS UI.
```
Your delete table request encountered issues. Replica cannot be deleted because it has acted as a source region for new replica(s) being added to the table in the last 24 hours..

Your delete table request encountered issues. User: arn:aws:sts::568431661506:assumed-role/ap-k8s-admin-cluster-568431661506/kerryw is not authorized to perform: application-autoscaling:DeregisterScalableTarget on resource: arn:aws:application-autoscaling:ap-southeast-2:568431661506:scalable-target/* because no identity-based policy allows the application-autoscaling:DeregisterScalableTarget action.

```

- When I try to manually delete the dynamodb repica from AWS UI.
  - First Try
  ```
  An error occurred when deleting the replica: The resource which you are attempting to change is in use.
  ```
  - wait 5 mins
  - Second Try
  ```
  Deleting the replica of the crossplane-terraform-dynamodb1-alpha-apse2-v1 table in the us-east-1 Region. This might take a few minutes.
  ```


- Got s3 access error 

```
echo "H4sIAAAAAAAA/5yQPY/aQBBA6+yvGLmNTTAmyLKUAkxQPsBEMSGBxlrbg73Ksmt21tjH/fkT91mcrrlqiqd5M3rsqzHaRIDXAYVBboWqIA0gb4v/aGEaL+FwjzRRI7lCz6Ix/KDN0aPA47KpuccbwpF39iOYFgUSxVpZo+VSkE20Tdum0cZiGcGmxidzqZFAaQtcSt1dDxH7QJbblqDQJUYwHg5dMHhqkSyIMoIf31azZPd3lmzTSbz9uXCh1o9ITYejZH7+/f20mez7P7WIlx1tL+G48/tFG3xqq/5X3Cefd8F8zf+pG1/naV6vRlXcXParj+s8oMkllFW4CL8wBtAJWwPvKKMge3g444UcvGTInjNkFLgMQCs4cqEG9gBSKATfd0EoMEi6NQWC88rmgPOGz4kYgO9H79yGW8buAAAA//8BAAD//0XynYXaAQAA" | base64 -d | gunzip


Error: error creating S3 bucket ACL for crossplane-terraform-s3-alpha-apse2-v1: AccessControlListNotSupported: The bucket does not allow ACLs
	status code: 400, request id: WWHXW9DHN8Q87D58, host id: aO3HDSiWEO1Au0M9EOzZmEn+pyv4AxVlJYSibOJBK/74FF+CcIPDCYjTCnjOtZUwN8kvsO2QWfJuvzlEY1c/yw==

  with aws_s3_bucket_acl.crossplane_terraform_s3,
  on main.tf line 11, in resource "aws_s3_bucket_acl" "crossplane_terraform_s3":
  11: resource "aws_s3_bucket_acl" "crossplane_terraform_s3" {
```
  - Set ownership to be created first and put depends_on in acl resource

- providerConfig error
```
Warning  CannotConnectToProvider  8s (x8 over 2m9s)  managed/workspace.tf.upbound.io  cannot get ProviderConfig: ProviderConfig.tf.upbound.io "default" not found
```
  - Update providerConfigRef in Composition Resource