data "aws_iam_policy_document" "es_access_policy_allow_all" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["es:ESHttpGet"]
    resources = ["arn:aws:es:${var.aws_region}:*:domain/${local.domain_name}/*"]
  }

//  statement {
//    principals {
//      type        = "AWS"
//      identifiers = ["*"]
//    }
//    actions   = ["es:*"]
//    resources = ["arn:aws:es:${var.aws_region}:*:domain/${local.domain_name}/*"]
//
//    condition {
//      test = "IpAddress"
//      values = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
//      variable = "aws:SourceIp"
//    }
//  }
}