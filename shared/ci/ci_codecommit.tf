resource "aws_codecommit_repository" "user_api_repository" {
  repository_name = "${var.project_prefix}.user_api"
  description     = "Server application for the Mobile App"
}

resource "aws_codecommit_repository" "headhunter_api_repository" {
  repository_name = "${var.project_prefix}.headhunter_api"
  description     = "Server application for the Headhunter App"
}