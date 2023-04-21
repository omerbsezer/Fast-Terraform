output "codecommit_configs" {
    value = {
        repository_name         = aws_codecommit_repository.codecommit_repo.repository_name
        default_branch          = aws_codecommit_repository.codecommit_repo.default_branch
        clone_repository_url    = aws_codecommit_repository.codecommit_repo.clone_url_http
    }
}