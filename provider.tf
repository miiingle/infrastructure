provider "aws" {
  region = var.aws_region
}

//provider "kubernetes" {
//  host                   = data.aws_eks_cluster.cluster.endpoint
//  token                  = data.aws_eks_cluster_auth.cluster.token
//  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
//}

terraform {
  required_version = ">= 0.14"
  //  backend "s3" {
  //    bucket  = "infrastructure.headhuntr.io"
  //    key     = "experimental/terraform.tfstate"
  //    region  = "us-west-2"
  //  }
}
