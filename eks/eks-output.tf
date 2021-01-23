output "lb_listener_arn" {
  value = data.aws_lb_listener.eks_load_balancer_elb.arn
}