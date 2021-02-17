
resource "aws_iam_role" "iam_codebuild_role" {
  name               = "miiingle-shared-codebuild-cw-role"
  assume_role_policy = data.template_file.codebuild_assume_policy.rendered
}

resource "aws_iam_role_policy" "iam_codebuild_role_inline_policy" {
  name   = "miiingle-shared-codebuild-role-inline-policy"
  role   = aws_iam_role.iam_codebuild_role.id
  policy = data.template_file.codebuild_policy.rendered
}

data "aws_s3_bucket" "codebuild_log_bucket" {
  bucket = var.log_bucket
}

data "template_file" "codebuild_policy" {
  template = file("${path.module}/template/codebuild_policy.json")
  vars = {
    aws_s3_bucket_arn = data.aws_s3_bucket.codebuild_log_bucket.arn
  }
}

data "template_file" "codebuild_assume_policy" {
  template = file("${path.module}/template/codebuild_assume_policy.json")
}