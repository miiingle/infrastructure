resource "aws_sns_topic" "alarms" {
  name = "${var.org}_${var.env}_alarms"
}

resource "aws_sns_topic_subscription" "sms_alarm" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "sms"
  endpoint  = var.alarm_sms_destination
}