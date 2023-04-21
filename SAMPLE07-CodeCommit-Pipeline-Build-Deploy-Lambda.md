## SAMPLE-07: Provisioning CodeCommit and CodePipeline, Triggering CodeBuild and CodeDeploy on Lambda Container

This sample shows:
- how to create 

**Notes:**
- Source code is pulled from:
  - https://github.com/aws-samples/codepipeline-for-lambda-using-terraform
- Some of the fields are updated. 
- It works with 'hashicorp/aws ~> 4.15.1', 'terraform >= 0.15'

There are 1 main part:
- **main.tf**:

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

### Main Part <a name="main_part"></a>

- Create main.tf:
 
```
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
```

**Code:** 

### CodeCommit Module <a name="codecommit"></a>

**Code:** 

### CodePipeline Module <a name="codepipeline"></a>

**Code:** 

### ECR Module <a name="ecr"></a>

**Code:** 

### Lambda Part <a name="lambda"></a>


**Code:** 

### Demo: Terraform Run <a name="run"></a>


## References
- https://github.com/aws-samples/codepipeline-for-lambda-using-terraform
