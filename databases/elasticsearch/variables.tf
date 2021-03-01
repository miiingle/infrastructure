variable "org" {}
variable "env" {}
variable "common_tags" {}

variable "aws_region" {}
variable "vpc_id" {}
variable "private_subnets" {}

variable "instance_count" {
  description = "The number of instances in the cluster"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "The machine that we want to use, this probably should never change at all"
  type        = string
  default     = "t2.small.elasticsearch"
}

variable "volume_size" {
  description = "The disk size in GB"
  type        = string
  default     = 35
}

variable "es_version" {
  description = "The engine version"
  type        = string
  default     = "7.9"
}