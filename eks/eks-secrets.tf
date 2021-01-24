resource "kubernetes_secret" "all_secrets" {
  metadata {
    name = "${var.org}.${var.env}.secrets"
  }

  data = var.secrets
}