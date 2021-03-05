output "sg_id" {
  value = aws_security_group.redis.id
}

output "port" {
  value = aws_elasticache_cluster.main.port
}

output "endpoint" {
  //TODO: when the cluster is > 1, this should be some sort of load balancer
  value = aws_elasticache_cluster.main.cache_nodes.0.address
}