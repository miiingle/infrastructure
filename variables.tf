
#Common
variable "org" {
  description = "Name of the Organization"
  type        = string
  default     = "miiingle"
}

variable "env" {
  description = "Name of the Environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS Resources created region"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Tags that we apply to all resources"
  type        = map(string)
  default = {
    "MiiingleEnv" = "dev"
  }
}

# Operations
# pro tip: set this using the env (export TF_VAR_alarm_sms_destination=6391xxxxxxx)
variable "alarm_sms_destination" {
  description = "Mobile number to send the Alarms via SNS"
  type        = string
  sensitive   = true
}

# VPC
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_cidrs" {
  description = "CIDR for public Subnet"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_cidrs" {
  description = "CIDR for private Subnet"
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
}

# EKS
variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "miiingle-dev-eks"
}

variable "eks_cluster_version" {
  type    = string
  default = "1.18"
}

# RDS
variable "rds_instance_type" {
  type    = string
  default = "db.r5.large"
}

variable "rds_instance_port" {
  type    = number
  default = 5432
}

# API Gateway
variable "api_gateway_domain_root" {
  description = "The domain that we want to address the api gateway endpoint"
  type        = string
  default     = "miiingle.net"
}

variable "api_gateway_domain_prefix" {
  description = "The subdomain for the api gateway"
  type        = string
  default     = "dev.api"
}