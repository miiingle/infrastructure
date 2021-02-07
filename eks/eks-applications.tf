resource "helm_release" "application_user_api" {
  provider        = helm.this_cluster
  name            = "user-api"
  chart           = "${path.module}/applications/user-api"
  cleanup_on_fail = true

  set {
    name  = "datasource.secretName"
    value = kubernetes_secret.all_secrets.metadata.0.name
  }

  depends_on = [
    module.eks_cluster,
    module.eks_cluster.config_map_aws_auth
  ]
}
//TODO: parameterize a lot of things:
//secrets
//resource+scaling