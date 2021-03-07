
module "network" {
  source            = "./network"
  aws_region        = var.aws_region
  org               = var.org
  env               = var.env
  common_tags       = var.common_tags
  vpc_cidr          = var.vpc_cidr
  public_cidrs      = var.public_cidrs
  private_cidrs     = var.private_cidrs
  eks_cluster_name  = var.eks_cluster_name
  rds_instance_port = var.rds_instance_port

  eks_worker_sg_id    = module.kubernetes.worker_sg_id
  rds_instance_sg_id  = module.rds.instance_sg_id
  es_instance_sg_id   = module.es.sg_id
  redis_cluster_sg_id = module.redis.sg_id
  redis_port          = module.redis.port
}

module "kubernetes" {
  source              = "./kubernetes"
  aws_region          = var.aws_region
  org                 = var.org
  env                 = var.env
  common_tags         = var.common_tags
  eks_cluster_name    = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  secrets = {
    rds_url      = "jdbc:postgresql://${module.rds.host}:5432/postgres?currentSchema=public"
    rds_username = module.rds.master_username
    rds_password = module.rds.master_password
  }

  rds_host     = module.rds.host
  rds_username = module.rds.master_username
  rds_password = module.rds.master_password

  redis_host = module.redis.endpoint
  redis_port = module.redis.port

  es_endpoint = module.es.endpoint
}

module "api_gateway" {
  source             = "./api-gateway"
  org                = var.org
  env                = var.env
  common_tags        = var.common_tags
  domain_root        = var.api_gateway_domain_root
  domain_prefix      = var.api_gateway_domain_prefix
  cors_allow_origins = var.api_gateway_cors_whitelist

  vpc_id                  = module.network.vpc_id
  vpc_link_subnets        = module.network.private_subnets
  backend_lb_listener_arn = module.kubernetes.lb_listener_arn
}

module "rds" {
  source              = "./databases/rds"
  org                 = var.org
  env                 = var.env
  common_tags         = var.common_tags
  instance_type       = var.rds_instance_type
  instance_port       = var.rds_instance_port
  snapshot_identifier = var.rds_snapshot_identifier

  vpc_id  = module.network.vpc_id
  subnets = module.network.private_subnets
}

module "es" {
  source      = "./databases/elasticsearch"
  org         = var.org
  env         = var.env
  common_tags = var.common_tags

  vpc_id          = module.network.vpc_id
  aws_region      = var.aws_region
  private_subnets = module.network.private_subnets
}

module "redis" {
  source      = "./databases/redis"
  org         = var.org
  env         = var.env
  common_tags = var.common_tags

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
}

module "operations" {
  source      = "./ops"
  org         = var.org
  env         = var.env
  common_tags = var.common_tags
  region      = var.aws_region

  alarm_sms_destination = var.alarm_sms_destination

  application_log_group = "/aws/containerinsights/${var.eks_cluster_name}/application"
  api_gateway_id        = module.api_gateway.api_id
  api_gateway_stage     = module.api_gateway.api_stage
  api_gateway_log_group = module.api_gateway.api_logs
  rds_instance_id       = module.rds.instance_id
}