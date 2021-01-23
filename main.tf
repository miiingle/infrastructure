
data "aws_caller_identity" "current" {}

module "vpc" {
  source           = "./vpc"
  aws_region       = var.aws_region
  org              = var.org
  env              = var.env
  common_tags      = var.common_tags
  vpc_cidr         = var.vpc_cidr
  public_cidrs     = var.public_cidrs
  private_cidrs    = var.private_cidrs
  eks_cluster_name = var.eks_cluster_name
}

module "eks" {
  source                   = "./eks"
  aws_region               = var.aws_region
  org                      = var.org
  env                      = var.env
  common_tags              = var.common_tags
  eks_cluster_version      = var.eks_cluster_version
  current_account_id       = data.aws_caller_identity.current.account_id
  eks_cluster_name         = var.eks_cluster_name
  eks_iam_mapping          = var.eks_iam_mapping
  eks_worker_instance_type = var.eks_worker_instance_type
  private_subnets          = module.vpc.private_subnets
  vpc_id                   = module.vpc.vpc_id
}