resource "aws_cloudwatch_metric_alarm" "api_error_5xx" {
  alarm_name                = "${local.alarm_namespace} API 5xx Rate Too High"
  alarm_description         = "Error 5xx are dangerously high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 5
  threshold                 = 0.01
  insufficient_data_actions = []

  alarm_actions = [aws_sns_topic.alarms.arn]

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
        ApiId = var.api_gateway_id
        Stage = var.api_gateway_stage
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
        ApiId = var.api_gateway_id
        Stage = var.api_gateway_stage
      }
    }

    return_data = false
  }
}

resource "aws_cloudwatch_metric_alarm" "api_no_requests" {
  alarm_name        = "${local.alarm_namespace} No request coming through"
  alarm_description = "No API Requests within 30 minutes"

  ok_actions         = [aws_sns_topic.alarms.arn]
  alarm_actions      = [aws_sns_topic.alarms.arn]
  treat_missing_data = "breaching"

  namespace   = "AWS/ApiGateway"
  metric_name = "Count"
  dimensions = {
    "ApiId" = var.api_gateway_id
    "Stage" = var.api_gateway_stage
  }
  statistic           = "Sum"
  period              = 600
  evaluation_periods  = 3
  comparison_operator = "LessThanThreshold"
  threshold           = 1
}