terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "tfstate-sandbox-hd-1337"
    key          = "aws-cloud-resume/terraform.tfstate"
    region       = "eu-west-3"
    use_lockfile = true
  }
  required_version = ">= 1.10"
}

provider "aws" {
  region = "eu-west-3"
}

