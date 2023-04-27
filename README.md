# ops-kube-crossplane-terraform
crossplane with terraform-provider

### TODO List
- How to setup terraform remote s3 as backend -> WIP

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

- How to solve `state lock` error -> WIP


