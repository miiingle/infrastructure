resource "helm_release" "application_user_api" {
  provider        = helm.this_cluster
  name            = "user-api"
  chart           = "${path.module}/applications/user-api"
  cleanup_on_fail = true

  set {
    name  = "datasource.secretName"
    value = kubernetes_secret.all_secrets.metadata.0.name
  }

  set {
    name  = "image.repository"
    value = "327229172692.dkr.ecr.us-east-1.amazonaws.com/miiingle.net.user_api"
  }

  set {
    name  = "image.tag"
    value = "latest"
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
    name  = "config.es.url"
    value = var.es_url
  }

  set {
    name  = "config.redis.url"
    value = var.redis_url
  }

  depends_on = [
    module.eks_cluster,
    module.eks_cluster.config_map_aws_auth
  ]
}