# Operations
# pro tip: set this using the env (export TF_VAR_alarm_sms_destination=6391xxxxxxx)
variable "alarm_sms_destination" {
  description = "Mobile number to send the Alarms via SNS"
  type        = string
  sensitive   = true
}

variable "cloudtrail_bucket_name" {
  default = "net.miiingle.shared.cloudtrail"
}