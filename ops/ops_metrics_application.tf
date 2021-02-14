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
    namespace     = local.metric_namespace
    name          = "EventCount"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api_gateway_error_5xx_count" {
  name           = "APIGatewayError5xx"
  pattern        = "{$.status=5**}"
  log_group_name = var.api_gateway_log_group

  metric_transformation {
    namespace     = local.metric_namespace
    name          = "HTTP_Error_5xx_Count"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api_gateway_error_4xx_count" {
  name           = "APIGatewayError4xx"
  pattern        = "{$.status=4**}"
  log_group_name = var.api_gateway_log_group

  metric_transformation {
    namespace     = local.metric_namespace
    name          = "HTTP_Error_4xx_Count"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api_gateway_ok_2xx_count" {
  name           = "APIGatewayOK2xx"
  pattern        = "{$.status=2**}"
  log_group_name = var.api_gateway_log_group

  metric_transformation {
    namespace     = local.metric_namespace
    name          = "HTTP_Response_2xx_Count"
    value         = "1"
    default_value = "0"
  }
}