resource "helm_release" "cluster_autoscaler" {
  provider        = helm.this_cluster
  name            = "cluster-autoscaler"
  chart           = "${path.module}/cluster-autoscaler"
  cleanup_on_fail = true

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  depends_on = [
    module.eks_cluster,
    module.eks_cluster.config_map_aws_auth
  ]
}