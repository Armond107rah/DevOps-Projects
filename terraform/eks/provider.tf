provider "aws" {
  region = "us-west-1"
  profile = "armond"

}
terraform {
required_providers {
  kubectl = {
    source  = "gavinbunney/kubectl"
    version = ">= 1.14.0"
  }
  helm = {
    source  = "hashicorp/helm"
    version = ">= 2.14.0"
  }
}

required_version = "~> 1.0"
}