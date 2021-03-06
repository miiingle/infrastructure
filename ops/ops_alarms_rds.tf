resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name          = "${local.alarm_namespace} RDS Low Storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = 20000000000
  alarm_description   = "Average database free storage space over last 10 minutes too low"

  alarm_actions = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "connection_usage_too_high" {
  alarm_name          = "${local.alarm_namespace} RDS Connection Too High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Average database connection usage over last 10 minutes too high, performance may suffer"

  alarm_actions = [aws_sns_topic.alarms.arn]
  ok_actions    = [aws_sns_topic.alarms.arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }
}