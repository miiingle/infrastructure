locals {
  root_domain  = "miiingle.net"
  email_domain = "mail.miiingle.net"
}

resource "aws_ses_domain_identity" "miiingle_customer_email" {
  domain = local.email_domain
}

resource "aws_ses_domain_dkim" "miiingle_dkim" {
  domain = aws_ses_domain_identity.miiingle_customer_email.domain
}

data "aws_route53_zone" "headhuntr_io_dns" {
  name         = local.root_domain
  private_zone = false
}

resource "aws_route53_record" "ses_verification" {
  zone_id = data.aws_route53_zone.headhuntr_io_dns.id
  name    = "_amazonses.${aws_ses_domain_identity.miiingle_customer_email.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.miiingle_customer_email.verification_token]
}

resource "aws_route53_record" "miiingle_amazonses_dkim_record" {
  count   = 3
  zone_id = data.aws_route53_zone.headhuntr_io_dns.id
  name    = "${element(aws_ses_domain_dkim.miiingle_dkim.dkim_tokens, count.index)}._domainkey.${local.email_domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.miiingle_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}