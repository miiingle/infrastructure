
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
  eks_cluster_name         = var.eks_cluster_name
  eks_iam_mapping          = var.eks_iam_mapping
  eks_worker_instance_type = var.eks_worker_instance_type

  current_account_id = data.aws_caller_identity.current.account_id
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  secrets = {
    rds_url      = "jdbc:postgresql://${module.rds.host}:5432/postgres?currentSchema=public"
    rds_username = module.rds.master_username
    rds_password = module.rds.master_password
  }
}

module "api_gateway" {
  source      = "./api-gateway"
  org         = var.org
  env         = var.env
  common_tags = var.common_tags

  vpc_id                  = module.vpc.vpc_id
  vpc_link_subnets        = module.vpc.private_subnets
  backend_lb_listener_arn = module.eks.lb_listener_arn
}

module "rds" {
  source        = "./rds"
  org           = var.org
  env           = var.env
  common_tags   = var.common_tags
  instance_type = var.rds_instance_type
  instance_port = var.rds_instance_port

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets
}

module "sg_rules" {
  source = "./sg-rules"

  rds_instance_port = var.rds_instance_port

  eks_worker_sg_id   = module.eks.worker_sg_id
  rds_instance_sg_id = module.rds.instance_sg_id
}