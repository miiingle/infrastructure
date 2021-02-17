resource "aws_cloudwatch_log_group" "code_build" {
  name              = "/miiingle/shared/codebuild"
  retention_in_days = 7
}