resource "aws_codecommit_repository" "user_api_repository" {
  repository_name = "${var.project_prefix}.user_api"
  description     = "Server application for the Mobile App"
}