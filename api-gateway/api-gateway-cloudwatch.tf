resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/${var.org}-${var.env}/api-gateway"
  retention_in_days = 7
  tags              = var.common_tags
}