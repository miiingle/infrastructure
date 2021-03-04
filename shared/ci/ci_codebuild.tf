resource "aws_codebuild_project" "user_api" {
  name        = "${var.project_prefix_alt}_user_api"
  description = aws_codecommit_repository.user_api_repository.description

  service_role  = aws_iam_role.iam_codebuild_role.arn
  badge_enabled = true

  source_version = "master"

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.user_api_repository.clone_url_http
  }

  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = "${var.build_cache_bucket}/${var.build_cache_prefix}/user_api"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.code_build.name
      stream_name = "user-api"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.log_bucket}/${var.log_prefix}/user_api"
    }
  }
}

resource "aws_codebuild_project" "headhunter_api" {
  name        = "${var.project_prefix_alt}_headhunter_api"
  description = aws_codecommit_repository.headhunter_api_repository.description

  service_role  = aws_iam_role.iam_codebuild_role.arn
  badge_enabled = true

  source_version = "master"

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.headhunter_api_repository.clone_url_http
  }

  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = "${var.build_cache_bucket}/${var.build_cache_prefix}/headhunter_api"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.code_build.name
      stream_name = "headhunter-api"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.log_bucket}/${var.log_prefix}/headhunter_api"
    }
  }
}