output "api_logs" {
  value = aws_cloudwatch_log_group.api_logs.name
}