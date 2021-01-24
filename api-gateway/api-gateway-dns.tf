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