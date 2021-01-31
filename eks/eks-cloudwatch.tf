locals {
  cloudwatch_namespace = "amazon-cloudwatch"
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

//TODO: VPC Endpoint for Xray
//TODO: figure out why zipkin is not reporting to xray, might need to check the code
resource "helm_release" "cloudwatch_utilities" {
  provider        = helm.this_cluster
  name            = "cloudwatch-utilities"
  chart           = "eks/cloudwatch-utilities"
  cleanup_on_fail = true

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "clusterRegion"
    value = var.aws_region
  }

  set {
    name = "clusterWorkerRoleARN"
    value = module.eks_cluster.worker_iam_role_arn
  }

  set {
    name  = "namespace"
    value = local.cloudwatch_namespace
  }

  depends_on = [kubernetes_namespace.cloudwatch]
}