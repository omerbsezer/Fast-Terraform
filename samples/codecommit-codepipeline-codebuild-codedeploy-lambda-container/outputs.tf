output "codepipeline" {
    value = module.codepipeline.codepipeline_configs.codepipeline
}
output "codecommit" {
    value = module.codecommit.codecommit_configs.clone_repository_url
}
output "ecrrepo" {
    value = module.ecr.ecr_configs.ecr_repo_url
}