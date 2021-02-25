
resource "aws_synthetics_canary" "user_api" {
  depends_on = [data.archive_file.canary_api_scripts]

  name                 = "mn_${var.env}_api_health"
  artifact_s3_location = "s3://${aws_s3_bucket.ops_shared_bucket.bucket}/canary/artifact"
  execution_role_arn   = aws_iam_role.canary_role.arn
  handler              = "apiHealthCheck.handler"
  start_canary         = true
  zip_file             = data.archive_file.canary_api_scripts.output_path
  runtime_version      = "syn-nodejs-puppeteer-3.0"

  run_config {
    active_tracing     = true
    timeout_in_seconds = 60
  }

  schedule {
    expression = "rate(10 minutes)"
  }
}

data "archive_file" "canary_api_scripts" {
  type        = "zip"
  source_dir  = "${path.module}/files/canaries/api/"
  output_path = "${path.module}/files/output/canary-api.zip"
}

resource "aws_iam_role" "canary_role" {
  name = "${var.org}-${var.env}-canary-role"
  tags = var.common_tags

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "canary_role_policy" {
  name   = "${var.org}-${var.env}-canary-policy"
  role   = aws_iam_role.canary_role.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.ops_shared_bucket.bucket}/canary/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.ops_shared_bucket.bucket}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:CreateLogGroup"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}::log-group:/aws/lambda/cwsyn-stg_site_avail-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "xray:PutTraceSegments"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": "cloudwatch:PutMetricData",
            "Condition": {
                "StringEquals": {
                    "cloudwatch:namespace": "CloudWatchSynthetics"
                }
            }
        }
    ]
}
POLICY
}