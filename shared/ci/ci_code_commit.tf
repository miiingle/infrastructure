resource "aws_codecommit_repository" "user_api_repository" {
  repository_name = "miiingle.net.user_api"
  description     = "Server application for the Mobile App"
}