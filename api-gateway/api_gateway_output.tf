
output "api_id" {
  value = aws_apigatewayv2_api.main.id
}

output "api_stage" {
  value = aws_apigatewayv2_stage.default.id
}

output "api_logs" {
  value = aws_cloudwatch_log_group.api_logs.name
}

