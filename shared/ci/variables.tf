variable "project_prefix" {
  default = "miiingle.net"
}

variable "project_prefix_alt" {
  default = "miiingle_net"
}

variable "build_cache_bucket" {
  type = string
}

variable "build_cache_prefix" {
  type    = string
  default = "build-cache"
}

variable "log_bucket" {
  type = string
}

variable "log_prefix" {
  type = string
}