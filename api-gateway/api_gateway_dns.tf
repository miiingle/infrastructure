//step 1: create and validate a cert
data "aws_route53_zone" "api" {
  count        = var.domain_root == "" ? 0 : 1
  name         = var.domain_root
  private_zone = false
}

resource "aws_acm_certificate" "api_gateway_ssl" {
  count = var.domain_root == "" ? 0 : 1

  domain_name       = "${var.domain_prefix}.${var.domain_root}"
  validation_method = "DNS"

  tags = merge(
    {
      Name = "API Gateway ${var.org} ${var.env} ${var.domain_prefix}.${var.domain_root}"
    },
    var.common_tags
  )
}

resource "aws_route53_record" "api_gateway_ssl_cert_validation" {
  depends_on = [aws_acm_certificate.api_gateway_ssl]
  count      = var.domain_root == "" ? 0 : 1

  zone_id = data.aws_route53_zone.api[count.index].zone_id
  name    = tolist(aws_acm_certificate.api_gateway_ssl[0].domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.api_gateway_ssl[0].domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.api_gateway_ssl[0].domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

//step 2: add the domain to api gateway
resource "aws_apigatewayv2_domain_name" "api_gateway" {
  depends_on = [aws_route53_record.api_gateway_ssl_cert_validation]
  count      = var.domain_root == "" ? 0 : 1

  domain_name = aws_acm_certificate.api_gateway_ssl[0].domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api_gateway_ssl[0].arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

//step 3: map the prod stage to the domain
resource "aws_apigatewayv2_api_mapping" "api_gateway" {
  depends_on = [aws_acm_certificate.api_gateway_ssl]
  count      = var.domain_root == "" ? 0 : 1

  domain_name = aws_apigatewayv2_domain_name.api_gateway[0].id
  api_id      = aws_apigatewayv2_api.main.id
  stage       = aws_apigatewayv2_stage.default.id
}

//step 4: add the record using route53
resource "aws_route53_record" "api_gateway_cname" {
  depends_on = [aws_apigatewayv2_api_mapping.api_gateway]
  count      = length(aws_apigatewayv2_api_mapping.api_gateway)

  zone_id = data.aws_route53_zone.api[0].zone_id
  name    = var.domain_prefix
  type    = "CNAME"
  records = aws_apigatewayv2_domain_name.api_gateway[0].domain_name_configuration.*.target_domain_name
  ttl     = 60
}