provider "aws" {
  region  = var.aws_region
}

terraform {
  required_version = ">= 0.14"
  backend "s3" {
    bucket  = "net.miiingle.shared.terraform"
    key     = "infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
