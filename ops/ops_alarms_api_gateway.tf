resource "aws_cloudwatch_metric_alarm" "api_error_5xx" {
  alarm_name                = "${local.alarm_namespace} API 5xx Rate Too High"
  alarm_description         = "Error 5xx are dangerously high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 5
  threshold                 = 0.01
  insufficient_data_actions = []

  treat_missing_data = "notBreaching"

  metric_query {
    id          = "errorRate"
    label       = "5XX Rate (%)"
    expression  = "error5xx / count"
    return_data = true
  }

  metric_query {
    id    = "count"
    label = "Count"

    metric {
      metric_name = "Count"
      namespace   = "AWS/ApiGateway"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ApiName = var.api_gateway_name
        Stage   = var.api_gateway_stage
      }
    }

    return_data = false
  }

  metric_query {
    id    = "error5xx"
    label = "5XX Error"

    metric {
      metric_name = "5XXError"
      namespace   = "AWS/ApiGateway"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ApiName = var.api_gateway_name
        Stage   = var.api_gateway_stage
      }
    }

    return_data = false
  }
}