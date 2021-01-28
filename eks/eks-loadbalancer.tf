resource "kubernetes_service" "load_balancer" {
  metadata {
    name = "${var.eks_cluster_name}-loadbalancer"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"                     = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-internal"                 = "true"
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

  //TODO: figure out the rest of the dependencies
  //bug - permissions were delete before this during destroy
  depends_on = [
    module.eks_cluster
  ]
}

# workaround to extract the LB name
locals {
  lb_hostname = kubernetes_service.load_balancer.status.0.load_balancer.0.ingress.0.hostname
  lb_name     = split("-", split(".", kubernetes_service.load_balancer.status.0.load_balancer.0.ingress.0.hostname).0).0
}

# LB that was created by AWS from the kubernetes service
data "aws_lb" "eks_load_balancer_elb" {
  name = local.lb_name
}

data "aws_lb_listener" "eks_load_balancer_elb" {
  load_balancer_arn = data.aws_lb.eks_load_balancer_elb.arn
  port              = 8080
}