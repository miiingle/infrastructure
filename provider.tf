provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.14"
  //  backend "s3" {
  //    bucket  = "infrastructure.headhuntr.io"
  //    key     = "experimental/terraform.tfstate"
  //    region  = "us-west-2"
  //  }
}
