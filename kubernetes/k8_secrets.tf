resource "kubernetes_secret" "all_secrets" {
  metadata {
    name = "${var.org}.${var.env}.secrets"
  }

  data = var.secrets

  depends_on = [
    module.eks_cluster
  ]
}

resource "kubernetes_secret" "rds_password" {
  metadata {
    name = "${var.org}.${var.env}.rds.password"
  }

  data = {
    password = var.rds_password
  }

  depends_on = [
    module.eks_cluster
  ]
}