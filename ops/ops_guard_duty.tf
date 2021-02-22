resource "aws_guardduty_detector" "master" {
  enable = true
}

resource "aws_cloudwatch_event_rule" "guard_duty_findings" {
  name        = "${var.org}-${var.env}-guard-duty-findings"
  description = "A CloudWatch Event Rule that triggers on Amazon GuardDuty findings. The Event Rule can be used to trigger notifications or remediation actions using AWS Lambda."
  is_enabled  = true

  event_pattern = <<PATTERN
{
  "detail-type": [
    "GuardDuty Finding"
  ],
  "source": [
    "aws.guardduty"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "guard_duty_to_sns" {
  target_id = "guard_duty_to_sns"
  rule      = aws_cloudwatch_event_rule.guard_duty_findings.name
  arn       = aws_sns_topic.alarms.arn

  input_transformer {
    input_paths = {
      title       = "$.detail.title",
      description = "$.detail.status",
      severity    = "$.detail.severity"
    }

    input_template = "\"<title> [<severity>]: <description>\""
  }
}