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

variable "domain_root" {
  description = "The base domain identifier that we should look for in route53, this is optional"
  type        = string
  default     = ""
}

variable "domain_prefix" {
  description = "The subdomain for the api gateway domain"
  type        = string
  default     = "api"
}

variable "cors_allow_origins" {
  default = ["https://dark-desert-6025.postman.co"]
}