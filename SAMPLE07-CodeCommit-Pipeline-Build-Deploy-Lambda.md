## SAMPLE-07: CI/CD on AWS => Provisioning CodeCommit and CodePipeline, Triggering CodeBuild and CodeDeploy on Lambda Container

This sample shows:
- how to create 

**Notes:**
- Source code is pulled from:
  - https://github.com/aws-samples/codepipeline-for-lambda-using-terraform
- Some of the fields are updated. 
- It works with 'hashicorp/aws ~> 4.15.1', 'terraform >= 0.15'

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container

![image](https://user-images.githubusercontent.com/10358317/233652299-66b39788-66ee-4a5e-b8e0-ece418fe98e3.png)

# Table of Contents
- [Main Part](#main_part)
- [CodeCommit Module](#codecommit)
- [CodePipeline Module](#codepipeline)
- [ECR Module](#ecr)
- [Lambda Part](#lambda)
- [Demo: Terraform Run](#run)

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- Code:

![image](https://user-images.githubusercontent.com/10358317/233652134-e5c732c0-1c88-4244-b321-b8f777476c85.png)

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

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/main.tf

- Create output.tf:

```
output "codepipeline" {
    value = module.codepipeline.codepipeline_configs.codepipeline
}
output "codecommit" {
    value = module.codecommit.codecommit_configs.clone_repository_url
}
output "ecrrepo" {
    value = module.ecr.ecr_configs.ecr_repo_url
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/outputs.tf

- Create providers.tf:

```
provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
      # Will allow installation of 4.15.1 and 4.15.10 but not 4.16.0
      # Get error when using 4.16.0
    }
  }
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/providers.tf

- Create terraform.tfvars:

```
org_name   = "org"
team_name  = "awsteam"
project_id = "lambda"
region     = "eu-central-1"
env = {
  "dev" = "dev"
  "qa"  = "qa"
}
codebuild_compute_type = "BUILD_GENERAL1_MEDIUM"
codebuild_image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
codebuild_type         = "LINUX_CONTAINER"
codecommit_branch      = "master"
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/terraform.tfvars

- Create variables.tf:

```
variable "org_name" {
  description = "Your Organization name"
  type        = string
}
variable "team_name" {
  description = "Your Team name"
  type        = string
}
variable "project_id" {
  description = "Your Project ID"
  type        = string
}
variable "env" {
  description = "Your deployment environment"
  type        = map(any)
  default = {
    "dev" = "dev"
  }
}
variable "region" {
  description = "Your AWS Region"
  type        = string
}
variable "codebuild_type" {
  description = "Your CodeBuild Project Type"
  type        = string
}
variable "codebuild_image" {
  description = "Your CodeBuild Project Image"
  type        = string
}
variable "codebuild_compute_type" {
  description = "Your CodeBuild Project Compute Type"
  type        = string
}
variable "codecommit_branch" {
  description = "Your CodeCommit Branch"
  type        = string
}
variable "terraform_ver" {
    description = "Terraform Version number for passing it to codebuild"
    default     = "1.2.2"
    type        = string
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/variables.tf

### CodeCommit Module <a name="codecommit"></a>

- Create main.tf:

```
data "aws_caller_identity" "current" {}
resource "aws_codecommit_repository" "codecommit_repo" {
  repository_name = "${var.general_namespace}_code_repo"
  default_branch  = "${var.codecommit_branch}"
  description     = "Application repo for lambda ${var.general_namespace}"
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codecommit/main.tf

- Create outputs.tf:

```
output "codecommit_configs" {
    value = {
        repository_name         = aws_codecommit_repository.codecommit_repo.repository_name
        default_branch          = aws_codecommit_repository.codecommit_repo.default_branch
        clone_repository_url    = aws_codecommit_repository.codecommit_repo.clone_url_http
    }
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codecommit/outputs.tf

- Create variables.tf:

```
variable "codecommit_branch" {
    type = string
    default = "master"
}
variable "general_namespace" {
    type = string
}
variable "env_namespace" {
    type = string
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codecommit/variables.tf

### CodePipeline Module <a name="codepipeline"></a>

- Create main.tf

```
locals {
  projects  = ["build", "deploy"]
}
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.s3_bucket_namespace}-codepipeline-bucket"
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  acl    = "private"
}

resource "aws_codebuild_project" "project" {
    count           = length(local.projects)
    name            = "${var.env_namespace}_${local.projects[count.index]}"
    #name           = "${var.org}_${var.name}_${var.attribute}_${var.env["dev"]}_codebuild_docker_build"
    build_timeout   = "5" #The default is 60 minutes.
    service_role    = aws_iam_role.lambda_codebuild_role.arn
    artifacts {
        type = "CODEPIPELINE"
    }
    environment {
      compute_type                = var.codebuild_compute_type
      image                       = var.codebuild_image
      type                        = var.codebuild_type
      #compute_type               = "BUILD_GENERAL1_MEDIUM"
      #image                      = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
      #type                       = "LINUX_CONTAINER"
      image_pull_credentials_type = "CODEBUILD"
      privileged_mode             = true

      dynamic "environment_variable" {
        for_each = var.build_args
        content {
          name  = environment_variable.value.name
          value = environment_variable.value.value
        }
      }
    }
    source {
        type      = "CODEPIPELINE"
        buildspec = file("${path.module}/templates/buildspec_${local.projects[count.index]}.yml")
        #buildspec = file("${path.module}/stage1-buildspec.yml")
    }

    source_version = "master"

    tags = {
        env = var.env_namespace
    }
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.env_namespace}_pipeline"
  role_arn = aws_iam_role.lambda_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeCommit"
      version  = "1"
      output_artifacts = [
      "source_output"]

      configuration = {
        #BranchName     = aws_codecommit_repository.lambda_codecommit_repo.default_branch
        BranchName      = var.codecommit_branch
        RepositoryName  = var.codecommit_repo
        #RepositoryName = aws_codecommit_repository.lambda_codecommit_repo.repository_name
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Docker_Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
      "source_output"]
      version = "1"

      configuration = {
        ProjectName = aws_codebuild_project.project[0].name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "Deploy_Docker"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
      "source_output"]
      version = "1"

      configuration = {
        ProjectName = aws_codebuild_project.project[1].name
      }
    }
  }
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codepipeline/main.tf

- Create outputs.tf

```
output "codepipeline_configs" {
    value = {
        codepipeline = aws_codepipeline.codepipeline.arn
    }
}
output "deployment_role_arn" {
    value = aws_iam_role.lambda_codebuild_role.arn
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codepipeline/outputs.tf


- Create roles.tf

```
resource "aws_iam_role" "lambda_codepipeline_role" {
  name = "${var.env_namespace}_codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_codepipeline_policy" {
  name = "${var.env_namespace}_codepipeline_policy"
  role = aws_iam_role.lambda_codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:*",
        "codecommit:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_codebuild_role" {
  name               = "${var.env_namespace}_codebuild_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_codebuild_role_policy" {
  role   = aws_iam_role.lambda_codebuild_role.name
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "sts:AssumeRole",
        "codebuild:*",
        "lambda:*",
        "iam:AddRoleToInstanceProfile",
        "iam:AttachRolePolicy",
        "iam:CreateInstanceProfile",
        "iam:CreatePolicy",
        "iam:CreateRole",
        "iam:GetRole",
        "iam:ListAttachedRolePolicies",
        "iam:ListPolicies",
        "iam:ListRolePolicies",
        "iam:ListRoles",
        "iam:PassRole",
        "iam:PutRolePolicy",
        "iam:UpdateAssumeRolePolicy",
        "iam:GetRolePolicy"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "${var.ecr_repo_arn}"
      ],
      "Action": [
        "ecr:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "ecr:GetAuthorizationToken"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*",
        "arn:aws:s3:::BUCKET_NAME",
        "arn:aws:s3:::BUCKET_NAME/*"
      ]
    }
  ]
}
POLICY
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codepipeline/roles.tf

- Create variables.tf

```
variable "codecommit_branch" {
    type = string
}
variable "codecommit_repo" {
    type = string
}
variable "general_namespace" {
    type = string
}
variable "env_namespace" {
    type = string
}
variable "s3_bucket_namespace" {
    type = string
}
variable "ecr_repo_arn" {
    type = string
}
variable "codebuild_image" {
    type = string
    default = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}
variable "codebuild_type" {
    type = string
    default = "LINUX_CONTAINER"
}
variable "codebuild_compute_type" {
    type = string
    default = "BUILD_GENERAL1_MEDIUM"
}
variable "build_args" {
    type        = any
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codepipeline/variables.tf

- Create buildspec_build.yml under templates:

```
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - IMAGE_URI=$REPO_URI:latest
      - echo $IMAGE_URI
  build:
    commands:
      - echo `ls -lrt`
      - echo Build started on `date`
      - echo Building the Docker image...          
      - docker build -t $IMAGE_URI ./lambda_bootstrap/lambda/
  post_build:
    commands:
      - bash -c "if [ /"$CODEBUILD_BUILD_SUCCEEDING/" == /"0/" ]; then exit 1; fi"
      - echo Build completed on `date`
      - echo Pushing the Docker image...
      - docker push $IMAGE_URI
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codepipeline/templates/buildspec_build.yml

- Create buildspec_deploy.yml under templates:

```
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.7
    commands:
      - tf_version=$TERRAFORM_VERSION
      - wget https://releases.hashicorp.com/terraform/"$TERRAFORM_VERSION"/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
      - unzip terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
      - mv terraform /usr/local/bin/
      - curl -sSLo install.sh https://install.hclq.sh
      - sh install.sh
  pre_build:
    commands:
      - echo Logging into Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
  build:
    commands:
      - echo Build started on `date`
      - terraform --version
      - cd lambda_bootstrap/
      - echo Updating ENV_namespace in terraform.tfvars
      - cat terraform.tfvars | hclq set 'env_namespace' $ENV_NAMESPACE | hclq set 'ecr_repo_url' $REPO_URI | hclq set 'ecr_repo_arn' $REPO_ARN | tee terraform.tfvars
      - terraform init -input=false
      - terraform validate
      - terraform apply -auto-approve
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/codepipeline/templates/buildspec_deploy.yml

### ECR Module <a name="ecr"></a>
- Create main.tf:

```
data "aws_caller_identity" "current" {}
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.general_namespace}_docker_repo"
  #image_tag_mutability = "IMMUTABLE" #a capability that prevents image tags from being overwritten
  image_scanning_configuration {
    scan_on_push = true #https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html
  }
  tags = {
    env = var.env_namespace
  }
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/ecr/main.tf


- Create outputs.tf:

```
output "ecr_configs" {
    value = {
        ecr_repo_url = aws_ecr_repository.ecr_repo.repository_url
        ecr_repo_arn = aws_ecr_repository.ecr_repo.arn
    }
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/ecr/outputs.tf

- Create variables.tf:

```
variable "general_namespace" {
    type = string
}
variable "env_namespace" {
    type = string
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/modules/ecr/variables.tf

### Lambda Part <a name="lambda"></a>
- Create main.tf:

```
data "aws_ecr_image" "lambda_image_latest" {
  repository_name = split("/", var.ecr_repo_url)[1]
  image_tag       = "latest"
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.env_namespace}_lambda_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "iam_policy_for_lambda" {
  role   = aws_iam_role.iam_for_lambda.name
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "${var.ecr_repo_arn}"
      ],
      "Action": [
        "ecr:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "ecr:GetAuthorizationToken"
      ]
    }
  ]
}
POLICY
}
resource "aws_lambda_function" "main" {
  function_name    = "${var.env_namespace}_lambda"
  image_uri        = "${var.ecr_repo_url}:latest"
  package_type     = "Image"
  role             = aws_iam_role.iam_for_lambda.arn
  source_code_hash = data.aws_ecr_image.lambda_image_latest.id
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/lambda_bootstrap/main.tf

- Create outputs.tf:
```
output "lambda_arn" {
    value = aws_lambda_function.main.arn
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/lambda_bootstrap/outputs.tf

- Create providers.tf:

```
provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
      # Will allow installation of 4.15.1 and 4.15.10 but not 4.16.0
      # Get error when using 4.16.0
    }
  }
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/lambda_bootstrap/providers.tf

- Create terraform.tfvars:

```
env_namespace = ""
ecr_repo_url = ""
ecr_repo_arn = ""
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/lambda_bootstrap/terraform.tfvars

- Create variables.tf:

```
variable "env_namespace" {
    type = string
    description = "Value is coming from tfvars file that is being updated by buildspec environment variables"
}
variable "ecr_repo_url" {
    type = string
    description = "Value is coming from tfvars file that is being updated by buildspec environment variables"
}
variable "ecr_repo_arn" {
    type = string
    description = "Value is coming from tfvars file that is being updated by buildspec environment variables"
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/lambda_bootstrap/variables.tf

**Lambda Details, Dockerfile:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container/lambda_bootstrap/lambda

### Demo: Terraform Run <a name="run"></a>

- Run:
 
```
terraform init
terraform validate
terraform plan
terraform apply
```

- Create IAM CodeCommit HTTPS Key on AWS IAM.
- Pull the repo from AWS CodeCommit, Copy the "lambda_bootstrap" into the code:

```
copy lambda_bootstrap 
git clone
git add . && git commit -m "Initial Commit" && git push
```
- On AWS CodeCommit, code is pushed:

- After pushing the code, it triggers CodePipeline:

- On AWS CodeBuild:

- On AWS CodeDeploy:

- On AWS Lambda:

- Testing interface with Lambda Test:

- Finally, destroy infrastructure:

```
terraform destroy -auto-approve
```

## References
- https://github.com/aws-samples/codepipeline-for-lambda-using-terraform
