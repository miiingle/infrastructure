output "sg_id" {
  value = aws_security_group.redis.id
}

output "port" {
  value = aws_elasticache_cluster.main.port
}

output "endpoint" {
  value = aws_elasticache_cluster.main.cluster_address
}