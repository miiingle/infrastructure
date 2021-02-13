variable "org" {}
variable "env" {}
variable "common_tags" {}
variable "region" {}

variable "alarm_sms_destination" {}
variable "application_log_group" {}

variable "api_gateway_log_group" {}
variable "api_gateway_name" {}
variable "api_gateway_stage" {}

variable "rds_instance_id" {}

locals {
  alarm_namespace = upper("${var.org}_${var.env} /")
}

