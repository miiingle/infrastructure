resource "aws_ecr_repository" "user_api" {
  name = "${var.project_prefix}.user_api"
}

resource "aws_ecr_lifecycle_policy" "user_api_cleanup" {
  repository = aws_ecr_repository.user_api.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images older than 14 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository" "headhunter_api" {
  name = "${var.project_prefix}.headhunter_api"
}

resource "aws_ecr_lifecycle_policy" "headhunter_api_cleanup" {
  repository = aws_ecr_repository.headhunter_api.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images older than 14 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository" "oracle_graalvm" {
  name = "${var.project_prefix}.oracle_graalvm"
}

