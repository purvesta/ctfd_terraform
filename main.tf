terraform {
  required_version = "> 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.9.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "ctfd" {
  source         = "./ctfd"
  region         = var.region
  az1            = var.az1
  az2            = var.az2
  # Comment out to default to us-west-2
  ctfd-ami       = var.ctfd-ami
  awx-ami        = var.ctfd-ami
  elb-account-id = "027434742980"
}
