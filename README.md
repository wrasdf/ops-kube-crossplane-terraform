# ops-kube-crossplane-terraform
Crossplane with terraform-provider

### Investigate Scenarios

- As a user, I would like to create a dynamodb with `Remote terraform moudle`.
  - Workspace mode -> passed
  - Composition mode -> passed

- As a user, I would like to create a s3 bucket with `terraform inline code` .
  - Workspace mode -> passed
  - Composition mode -> passed

- As a user, I would like to setup Kuernetes Secrets as terraform backend to store the state. 
  - tf-status in the secrets of `upbound-system` namespace. eg:
    - tfstate-workspace-crossplane-terraform-s3-alpha-apse2-v1-crossplane-terraform-provider-config-alpha-apse2-v1

- As an admin user, I would like to config IRSA for terraform-provider.

- As a user/admin user, how could I debug the issues.
  - k get s3
  - k get dynamodb
  - k get Composition

  - k get workspace
  - k describe ...

- As a user/admin user, I would like to delete workspace resource.
  - AWS resources wil be deleted as well
  - Notes: 
    - Need to remove `finalizer` in workspace first

- As a user/admin user, I would like to delete Compoistion `Claim` resource. 
  - Workspace will be deleted. 
  - AWS resources wil be deleted as well


### Issus (01/05/2023)
- add `writeConnectionSecretToRef` in Composition resource will cause workspace could not be created.
- `ToCompositeFieldPath` in patches of Composition resource not showing the output status.


### Known limits (01/05/2023)
- https://github.com/upbound/provider-terraform/blob/main/README.md#known-limitations

- Not support `remote backend state` with ProviderConfig for compostion mode. eg: s3
  - https://github.com/upbound/provider-terraform/issues/49

### Hackway to get more terraform features  (02/05/2023)
- Hack steps:
  - kubectl get pods -n upbound-system 
  - kubectl exec -it crossplane-provider-terraform-* -- bash
    - cd /tf/<3ae97dd0-e129-4af4-baf5-d8da03b1dcc1>
    - terraform init
    - terraform plan
    - terraform apply
    - terraform import 

- The terraform features are not offically support yet:
  - `terraform plan` show diff for us
    - https://github.com/upbound/provider-terraform/issues/86

  - `state lock` issue during pod restart/update
    - https://github.com/crossplane-contrib/provider-terraform/issues/46

  - `import values` to existing terraform status.  

