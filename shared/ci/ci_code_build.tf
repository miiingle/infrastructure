//resource "aws_codebuild_project" "user_api" {
//
//  name = "${var.project_prefix}.user_api"
//  service_role = ""
//  badge_enabled = true
//
//  source {
//    type = "CODECOMMIT"
//    location = aws_codecommit_repository.user_api_repository.arn
//  }
//
//  artifacts {
//    type = "NO_ARTIFACTS"
//  }
//
//  environment {
//    compute_type = ""
//    image = ""
//    type = ""
//  }
//
//  logs_config {
//    cloudwatch_logs {
//      group_name  = "log-group"
//      stream_name = "log-stream"
//    }
//
//    s3_logs {
//      status   = "ENABLED"
//      location = "${var.log_bucket}/${var.log_prefix}/user_api"
//    }
//  }
//}