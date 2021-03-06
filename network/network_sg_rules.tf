resource "aws_security_group_rule" "eks_worker_to_rds" {
  description              = "Worker nodes access to RDS"
  from_port                = var.rds_instance_port
  to_port                  = var.rds_instance_port
  protocol                 = "tcp"
  security_group_id        = var.rds_instance_sg_id
  source_security_group_id = var.eks_worker_sg_id
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_worker_to_es" {
  description              = "Worker nodes access to ES"
  from_port                = var.es_instance_port
  to_port                  = var.es_instance_port
  protocol                 = "tcp"
  security_group_id        = var.es_instance_sg_id
  source_security_group_id = var.eks_worker_sg_id
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_worker_to_redis" {
  description              = "Worker nodes access to Redis"
  from_port                = var.redis_port
  to_port                  = var.redis_port
  protocol                 = "tcp"
  security_group_id        = var.redis_cluster_sg_id
  source_security_group_id = var.eks_worker_sg_id
  type                     = "ingress"
}