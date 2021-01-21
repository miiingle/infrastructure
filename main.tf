
module "vpc" {
  source           = "./vpc"
  aws_region       = var.aws_region
  org              = var.org
  env              = var.env
  vpc_cidr         = var.vpc_cidr
  public_cidrs     = var.public_cidrs
  private_cidrs    = var.private_cidrs
  eks_cluster_name = var.eks_cluster_name
}

