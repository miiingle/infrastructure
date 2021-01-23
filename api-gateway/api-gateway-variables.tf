variable "aws_region" {}
variable "org" {}
variable "env" {}
variable "common_tags" {}
variable "vpc_id" {}
variable "vpc_link_subnets" {}
variable "backend_lb_listener_arn" {}

variable "http_methods" {
  description = "The HTTP Methods that are allowed to operate on our resources"
  type        = list(string)
  default     = ["GET", "POST", "PUT", "PATCH", "DELETE"]
}