locals {
  metric_namespace = "Application/${var.org}-${var.env}"
}

//aws docs
//https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
resource "aws_cloudwatch_log_metric_filter" "user_registration_count" {
  name           = "UserRegistrationCount"
  pattern        = "Email"
  log_group_name = var.application_log_group

  metric_transformation {
    name      = "EventCount"
    namespace = local.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api_gateway_error_5xx_count" {
  name           = "APIGatewayError5xx"
  pattern        = "ERROR"
  log_group_name = var.api_gateway_log_group

  metric_transformation {
    name      = "EventCount"
    namespace = local.metric_namespace
    value     = "1"
  }
}