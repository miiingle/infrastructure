
resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name          = "${aws_db_instance.db_transaction.identifier}_free_storage_space_threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = 20000000000
  alarm_description   = "Average database free storage space over last 10 minutes too low"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_transaction.id
  }
}