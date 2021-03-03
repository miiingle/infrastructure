locals {
  subnet_group_name = "${var.org}-${var.env}-redis-subnet"
}

resource "aws_elasticache_cluster" "main" {
  depends_on = [aws_elasticache_subnet_group.main]

  cluster_id           = "${var.org}-${var.env}-redis"
  engine               = "redis"
  node_type            = "cache.r5.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.0.5"

  subnet_group_name  = local.subnet_group_name
  security_group_ids = [aws_security_group.redis.id]
  port               = 6379
}

resource "aws_elasticache_subnet_group" "main" {
  name        = local.subnet_group_name
  description = "Redis Cluster Subnet Group"
  subnet_ids  = var.private_subnets
}