terraform {
  required_version = "~> 1.4.4"
  backend "s3" {
    key = "crossplane-terraform/<< .config.clusterName >>/crossplane-terraform.tfstate"
    bucket  = "ops-kube-crossplane-terraform-<< .config.aws.accountId >>-<< .config.clusterName >>"
    region = "<< .config.aws.region >>"
  }
}

provider "aws" {
  region = "<< .config.aws.region >>"
  default_tags {
    tags = local.default_tags
  }
}