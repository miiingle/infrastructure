data "aws_iam_policy_document" "es_access_policy_allow_all" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["es:ESHttpGet"]
    resources = ["arn:aws:es:${var.aws_region}:*:domain/${local.domain_name}/*"]
    condition = {
      IpAddress = {
        "aws:SourceIp" = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
      }
    }
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["es:*"]
    resources = ["arn:aws:es:${var.aws_region}:*:domain/${local.domain_name}/*"]
    condition = {
      IpAddress = {
        "aws:SourceIp" = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
      }
    }
  }
}

//TODO: vars for public/private subnet ip range