resource "aws_codebuild_project" "user_api" {
  name        = "${var.project_prefix_alt}_user_api"
  description = ""

  service_role  = aws_iam_role.iam_codebuild_role.arn
  badge_enabled = true

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.user_api_repository.clone_url_http
  }
  source_version = "master"

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }

    environment_variable {
      name  = "SOME_KEY2"
      value = "SOME_VALUE2"
      type  = "PARAMETER_STORE"
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
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