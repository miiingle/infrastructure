resource "aws_ecr_repository" "user_api" {
  name = "${var.project_prefix}.user_api"
}