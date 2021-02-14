variable "aws_region" {}
variable "org" {}
variable "env" {}
variable "common_tags" {}
variable "vpc_id" {}
variable "private_subnets" {}
variable "eks_cluster_name" {}
variable "eks_cluster_version" {}

variable "secrets" {
  description = "Credentials that you want K8 to keep for the app"
  type        = map(string)
  default     = {}
}