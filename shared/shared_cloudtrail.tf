resource "aws_cloudtrail" "global" {
  depends_on = [aws_s3_bucket.cloudtrail]

  name                          = "miiingle-trail"
  is_multi_region_trail         = true
  include_global_service_events = true

  s3_bucket_name             = aws_s3_bucket.cloudtrail.bucket
  s3_key_prefix              = "cloudtrail"
  enable_log_file_validation = true

  enable_logging             = true
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.iam_cloudtrail_role.arn

  event_selector {
    include_management_events = true
    read_write_type           = "WriteOnly"
  }
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/miiingle/shared/cloudtrail"
  retention_in_days = 7
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = var.cloudtrail_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  policy = data.template_file.cloudtrail_bucket_policy.rendered

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket_access" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "template_file" "cloudtrail_bucket_policy" {
  template = file("${path.module}/template/cloudtrail_bucket_policy.json")

  vars = {
    bucket = var.cloudtrail_bucket_name
  }
}

resource "aws_iam_role" "iam_cloudtrail_role" {
  name               = "miiingle-shared-cloudtrail-cw-role"
  assume_role_policy = data.template_file.cloudtrail_assume_role_policy.rendered
}

resource "aws_iam_role_policy" "iam_cloudtrail_role_inline_policy" {
  name   = "miiingle-shared-cloudtrail-cw-role-inline-policy"
  role   = aws_iam_role.iam_cloudtrail_role.id
  policy = data.template_file.cloudtrail_loggroup_policy.rendered
}

data "template_file" "cloudtrail_assume_role_policy" {
  template = file("${path.module}/template/cloudtrail_assume_role_policy.json")
}

//TODO: narrow this down, though its AWS, we can trust it no matter what
data "template_file" "cloudtrail_loggroup_policy" {
  template = file("${path.module}/template/cloudtrail_loggroup_policy.json")
}
