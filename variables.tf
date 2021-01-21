
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

#VPC
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
  default     = "eks"
}