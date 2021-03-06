variable "aws_region" {}
variable "org" {}
variable "env" {}
variable "common_tags" {}
variable "vpc_cidr" {}
variable "public_cidrs" {}
variable "private_cidrs" {}
variable "eks_cluster_name" {}

variable "eks_worker_sg_id" {}

variable "rds_instance_sg_id" {}
variable "rds_instance_port" {
  default = 5432
}

variable "es_instance_sg_id" {}
variable "es_instance_port" {
  default = 443
}

variable "redis_cluster_sg_id" {}
variable "redis_port" {
  default = 6379
}
