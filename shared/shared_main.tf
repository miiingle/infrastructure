
module "ci" {
  source = "./ci"

  log_bucket = aws_s3_bucket.cloudtrail.bucket
  log_prefix = "code_pipeline"

  build_cache_bucket = aws_s3_bucket.backend.bucket
}