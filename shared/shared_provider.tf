provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket  = "net.miiingle.shared.terraform"
    key     = "shared/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}