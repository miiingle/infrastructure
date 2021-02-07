module "eks_cluster" {
  source           = "terraform-aws-modules/eks/aws"
  cluster_name     = var.eks_cluster_name
  cluster_version  = var.eks_cluster_version
  vpc_id           = var.vpc_id
  subnets          = var.private_subnets
  write_kubeconfig = false
  manage_aws_auth  = var.manage_aws_auth

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  //TODO: configure separately eks-kubernetes-users.tf
  map_accounts = [var.current_account_id]
  map_users = [
    for user, iam in var.eks_iam_mapping :
    {
      userarn  = "arn:aws:iam::${var.current_account_id}:user/${iam}"
      username = user
      groups   = ["system:masters"]
    }
  ]

  node_groups_defaults = {
    desired_capacity = 1
    min_capacity     = 1
  }

  node_groups = [
    {
      name           = "${var.org}-${var.env}-eks-worker-on-demand"
      capacity_type  = "ON_DEMAND"
      instance_types = ["c5.xlarge"]
      max_capacity   = 1

      additional_tags = merge({
        Name = "${var.org}-${var.env}-eks-worker-on-demand"
      }, var.common_tags)
    },

    {
      name           = "${var.org}-${var.env}-eks-worker-spot"
      capacity_type  = "SPOT"
      instance_types = ["c5.2xlarge"]
      max_capacity   = 5

      additional_tags = merge({
        Name = "${var.org}-${var.env}-eks-worker-spot"
      }, var.common_tags)
    }
  ]

  worker_create_security_group  = false
  cluster_create_security_group = false

  tags = var.common_tags
}