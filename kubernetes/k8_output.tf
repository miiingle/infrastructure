output "lb_listener_arn" {
  value = data.aws_lb_listener.eks_load_balancer_elb.arn
}

output "worker_sg_id" {
  value = module.eks_cluster.cluster_primary_security_group_id
}