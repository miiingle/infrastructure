resource "aws_apigatewayv2_api" "main" {
  name          = "${var.org}-${var.env}-api-gateway"
  description   = "API Gateway for ${var.org} / ${var.env}"
  protocol_type = "HTTP"
  tags          = var.common_tags

  cors_configuration {
    allow_origins     = var.cors_allow_origins
    allow_credentials = false
    allow_headers     = ["*"]
    allow_methods     = ["*"]
    max_age           = 300
  }
}

resource "aws_apigatewayv2_vpc_link" "backend_application" {
  name               = "${aws_apigatewayv2_api.main.name}-vpc-link"
  security_group_ids = [aws_security_group.apigw_sg.id]
  subnet_ids         = var.vpc_link_subnets
  tags               = var.common_tags
}

resource "aws_apigatewayv2_integration" "backend_application" {
  api_id             = aws_apigatewayv2_api.main.id
  description        = "Integrate to the main Backend"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.backend_application.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = var.backend_lb_listener_arn
}

resource "aws_apigatewayv2_route" "eks_internal_http_methods" {
  count          = length(var.http_methods)
  api_id         = aws_apigatewayv2_api.main.id
  route_key      = "${var.http_methods[count.index]} /{proxy+}"
  operation_name = "${var.http_methods[count.index]} Resource"
  target         = "integrations/${aws_apigatewayv2_integration.backend_application.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  description = "Default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode(
      {
        httpMethod     = "$context.httpMethod"
        stage          = "$context.stage"
        path           = "$context.path"
        ip             = "$context.identity.sourceIp"
        protocol       = "$context.protocol"
        requestId      = "$context.requestId"
        requestTime    = "$context.requestTime"
        responseLength = "$context.responseLength"
        status         = "$context.status"
      }
    )
  }

  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = true
    throttling_burst_limit   = 5000
    throttling_rate_limit    = 10000
  }

  tags = var.common_tags
}