
//TODO: send pod logs to cloudwatch using Fluent Bit
//https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-EKS-quickstart.html

locals {
  cloudwatch_namespace = "amazon-cloudwatch"
}

//TODO: change this to a more restrictive role
resource "aws_iam_role_policy_attachment" "cluster_CloudWatchFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = module.eks_cluster.worker_iam_role_name
}

resource "kubernetes_namespace" "cloudwatch" {
  metadata {
    name = local.cloudwatch_namespace
    labels = {
      name = local.cloudwatch_namespace
    }
  }

  depends_on = [
    module.eks_cluster,
    module.eks_cluster.config_map_aws_auth
  ]
}

resource "kubernetes_config_map" "fluent_bit_cluster_info" {
  metadata {
    name      = "fluent-bit-cluster-info"
    namespace = local.cloudwatch_namespace
  }

  data = {
    "cluster.name" = var.eks_cluster_name
    "http.port"    = "2020"
    "http.server"  = "On"
    "logs.region"  = var.aws_region
    "read.head"    = "Off"
    "read.tail"    = "On"
  }

  depends_on = [
    kubernetes_namespace.cloudwatch
  ]
}

//TODO: apply fluent-bit.yml