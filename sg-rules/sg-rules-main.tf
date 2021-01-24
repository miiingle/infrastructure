resource "aws_security_group_rule" "eks_worker_to_" {
  description              = "Worker nodes access to RDS"
  from_port                = var.rds_instance_port
  to_port                  = var.rds_instance_port
  protocol                 = "tcp"
  security_group_id        = var.rds_instance_sg_id
  source_security_group_id = var.eks_worker_sg_id
  type                     = "ingress"
}