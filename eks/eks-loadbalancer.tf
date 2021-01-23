resource "kubernetes_service" "load_balancer" {
  metadata {
    name = "${var.eks_cluster_name}-loadbalancer"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"
      "service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags" = "ClusterName=${var.eks_cluster_name}"
    }
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "miiingle"
    }
    port {
      port        = 8080
      target_port = 8080
    }
  }
}

# workaround to extract the ELB name
locals {
  lb_hostname = kubernetes_service.load_balancer.status.0.load_balancer.0.ingress.0.hostname
  lb_name = split("-", split(".", kubernetes_service.load_balancer.status.0.load_balancer.0.ingress.0.hostname).0).0
}

# ELB that was created by AWS from the kubernetes service
data "aws_lb" "eks_load_balancer_elb" {
  name = local.lb_name
}