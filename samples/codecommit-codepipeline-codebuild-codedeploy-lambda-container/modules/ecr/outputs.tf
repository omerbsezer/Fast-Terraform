output "ecr_configs" {
    value = {
        ecr_repo_url = aws_ecr_repository.ecr_repo.repository_url
        ecr_repo_arn = aws_ecr_repository.ecr_repo.arn
    }
}