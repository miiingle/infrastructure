resource "helm_release" "application_user_api" {
  provider        = helm.this_cluster
  name            = "user-api"
  chart           = "${path.module}/applications/user-api"
  cleanup_on_fail = true

  set {
    name  = "image.repository"
    value = "327229172692.dkr.ecr.us-east-1.amazonaws.com/miiingle.net.user_api"
  }

  set {
    name  = "image.tag"
    value = "latest-native"
  }

  set {
    name  = "config.rds.host"
    value = var.rds_host
  }

  set {
    name  = "config.rds.username"
    value = var.rds_username
  }

  set {
    name  = "config.rds.passwordSecretName"
    value = kubernetes_secret.rds_password.metadata.0.name
  }

  depends_on = [
    module.eks_cluster,
    module.eks_cluster.config_map_aws_auth
  ]
}

resource "helm_release" "application_headhunter_api" {
  provider        = helm.this_cluster
  name            = "headhunter-api"
  chart           = "${path.module}/applications/headhunter-api"
  cleanup_on_fail = true

  set {
    name  = "config.rds.host"
    value = var.rds_host
  }

  set {
    name  = "config.rds.username"
    value = var.rds_username
  }

  set {
    name  = "config.rds.passwordSecretName"
    value = kubernetes_secret.rds_password.metadata.0.name
  }

  set {
    name  = "config.es.endpoint"
    value = var.es_endpoint
  }

  set {
    name  = "config.redis.host"
    value = var.redis_host
  }

  set {
    name  = "config.redis.port"
    value = var.redis_port
  }

  depends_on = [
    module.eks_cluster,
    module.eks_cluster.config_map_aws_auth
  ]
}