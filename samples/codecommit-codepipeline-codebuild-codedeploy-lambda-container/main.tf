locals {
  env_namespace         = join("_", [var.org_name, var.team_name, var.project_id, var.env["dev"]])
  general_namespace     = join("_", [var.org_name, var.team_name, var.project_id])
  #s3 bucket naming based on best practices: https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  s3_bucket_namespace   = join("-", [var.org_name, var.team_name, var.project_id, var.env["dev"]])
}
data "aws_caller_identity" "current" {}
module "codepipeline" {
  source                 = "./modules/codepipeline"
  general_namespace      = local.general_namespace
  env_namespace          = local.env_namespace
  s3_bucket_namespace    = local.s3_bucket_namespace
  codecommit_repo        = module.codecommit.codecommit_configs.repository_name
  codecommit_branch      = module.codecommit.codecommit_configs.default_branch
  codebuild_image        = var.codebuild_image
  codebuild_type         = var.codebuild_type
  codebuild_compute_type = var.codebuild_compute_type
  ecr_repo_arn           = module.ecr.ecr_configs.ecr_repo_arn
  build_args = [
    {
      name  = "REPO_URI"
      value = module.ecr.ecr_configs.ecr_repo_url
    },
    {
      name  = "REPO_ARN"
      value = module.ecr.ecr_configs.ecr_repo_arn
    },
    {
      name  = "TERRAFORM_VERSION"
      value = var.terraform_ver
    },
    {
      name  = "ENV_NAMESPACE"
      value = local.env_namespace
    },
    {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
  ]
}

module "codecommit" {
  source            = "./modules/codecommit"
  general_namespace = local.general_namespace
  env_namespace     = local.env_namespace
  codecommit_branch = var.codecommit_branch
}

module "ecr" {
  source            = "./modules/ecr"
  general_namespace = local.general_namespace
  env_namespace     = local.env_namespace
}