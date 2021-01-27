provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_cluster.cluster_id
}

module "eks_cluster" {
  source           = "terraform-aws-modules/eks/aws"
  cluster_name     = var.eks_cluster_name
  cluster_version  = var.eks_cluster_version
  vpc_id           = var.vpc_id
  subnets          = var.private_subnets
  write_kubeconfig = false

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

  //TODO: configure separately eks-main-worker.tf
  //TODO: use spot
  //https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/spot-instances.md
  node_groups = [
    {
      name = "${var.org}-${var.env}-worker"

      k8s_labels = {
        Environment = var.env
        Type        = "standard"
      }

      instance_type    = var.eks_worker_instance_type
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 10
      subnets          = var.private_subnets

      additional_tags = merge({
        Name = "${var.org}-${var.env}-eks-worker"
      }, var.common_tags)
    }
  ]

  worker_create_security_group  = false
  cluster_create_security_group = false

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "cluster_AWSXRayDaemonWriteAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  role       = module.eks_cluster.worker_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = module.eks_cluster.worker_iam_role_name
}
