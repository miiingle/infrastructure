resource "aws_ecr_repository" "user_api" {
  name = "${var.project_prefix}.user_api"
}

resource "aws_ecr_repository" "oracle_graalvm" {
  name = "${var.project_prefix}.oracle_graalvm"
}