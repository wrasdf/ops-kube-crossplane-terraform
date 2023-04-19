terraform {
  required_version = "~> 1.4.4"
  backend "s3" {
    key = "dynamodb/<< .config.clusterName >>/dynamodb_name.tfstate"
    bucket  = "ops-kube-dynamodb-<< .config.aws.accountId >>-<< .config.clusterName >>"
    region = "<< .config.aws.region >>"
  }
}

provider "aws" {
  region = "<< .config.aws.region >>"
  default_tags {
    tags = local.default_tags
  }
}
