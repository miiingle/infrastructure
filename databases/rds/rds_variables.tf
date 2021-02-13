variable "org" {}
variable "env" {}
variable "common_tags" {}
variable "vpc_id" {}
variable "subnets" {}
variable "instance_type" {}
variable "instance_port" {}

variable "db_name" {
  description = "The initial database to create"
  type        = string
  default     = "postgres"
}