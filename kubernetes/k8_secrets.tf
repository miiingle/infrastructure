resource "kubernetes_secret" "all_secrets" {
  metadata {
    name = "${var.org}.${var.env}.secrets"
  }

  data = var.secrets

  depends_on = [
    module.eks_cluster
  ]
}