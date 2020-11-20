variable "environment" {}

resource "aws_ecr_repository" "repository" {
  name = "repairs-api/${var.environment}"
}

output "repository_url" {
  value = aws_ecr_repository.repository.repository_url
}
