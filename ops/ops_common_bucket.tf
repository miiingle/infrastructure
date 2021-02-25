
resource "aws_s3_bucket" "ops_shared_bucket" {
  bucket = "net.miiingle.${var.env}.ops"
  acl    = "private"

  force_destroy = true
}