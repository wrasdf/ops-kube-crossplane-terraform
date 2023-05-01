# ops-kube-crossplane-terraform
crossplane with terraform-provider

### Investigate Scenarios

- How to setup terrform kubernetes as backend -> ok
  - tf-status in the secrets of k8s upbound-system namespace:
    - tfstate-workspace-crossplane-terraform-s3-alpha-apse2-v1-crossplane-terraform-provider-config-alpha-apse2-v1

- How does terraform-provider works with IRSA -> ok

- How to create dynamodb (remote module)
  - workspace -> ok
  - composition - ok

- How to create s3
  - workspace -> ok
  - composition -> ok

- How to debug the issues
  - k get s3
  - k get dynamodb
  - k get Composition

  - k get workspace
  - k describe ...

- How to delete workspace -> ok
  - AWS resources wil be deleted as well
  - Notes: 
    - Need to remove `finalizer` in workspace first

- How to delete Composition `Claim` -> ok
  - Workspace will be deleted 
  - AWS resources wil be deleted as well


### Issus
- add `writeConnectionSecretToRef` in Composition resource failed for workspace resource.
- `ToCompositeFieldPath` in patches of Composition resource seems not working as expected.


### Known limits
- https://github.com/upbound/provider-terraform/blob/main/README.md#known-limitations

- Not support `terraform plan` show diff for us
  - https://github.com/upbound/provider-terraform/issues/86

- Not support `import values` to existing terraform status.

- Hard to handle `state lock` during pod restart/update
  - https://github.com/crossplane-contrib/provider-terraform/issues/46

- Not support remote backend state with ProviderConfig for compostion mode. eg: s3
