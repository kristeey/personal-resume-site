// Create a ECR repo to hold docker images from CI pipeline
resource "aws_ecr_repository" "resume-app-ecr" {
  name = var.ecr_repo_name
}