variable "aws_region" {}
variable "org" {}
variable "env" {}
variable "common_tags" {}
variable "vpc_id" {}
variable "private_subnets" {}
variable "eks_cluster_name" {}
variable "eks_iam_mapping" {}
variable "eks_worker_instance_type" {}
variable "eks_cluster_version" {}

variable "current_account_id" {
  description = "The account id of the current user"
  type        = string
}

variable "secrets" {
  description = "Credentials that you want K8 to keep for the app"
  type        = map(string)
  default     = {}
}