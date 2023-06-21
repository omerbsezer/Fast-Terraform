data "template_file" "deploybuildspec" {
  template = file("modeldeploy_buildspec.yml")  # connect to buildspec file
  vars = {
    env = var.env
    SAGEMAKER_PROJECT_NAME=var.project_name
    SAGEMAKER_PROJECT_ID=var.project_id
    ARTIFACT_BUCKET=var.artifacts_bucket_name
    MODEL_EXECUTION_ROLE_ARN=aws_iam_role.tf_mlops_role.arn
    AWS_REGION=var.region
    SOURCE_MODEL_PACKAGE_GROUP_NAME="${var.project_name}-${var.project_id}"
    EXPORT_TEMPLATE_NAME="template-export.yml"
    EXPORT_TEMPLATE_STAGING_CONFIG="staging-config-export.json"
    EXPORT_TEMPLATE_PROD_CONFIG="prod-config-export.json"

  }
}

resource "aws_codebuild_project" "tf_mlops_deploybuild" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "tf-mlops-deploybuild"
  queued_timeout = 480
  service_role   = aws_iam_role.tf_mlops_role.arn
  tags = {
    Environment = var.env
  }

  artifacts {
    encryption_disabled    = false
    name                   = "tf-mlops-deploybuild-${var.env}"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
    environment_variable {
      name  = "environment"
      type  = "PLAINTEXT"
      value = var.env
    }
    environment_variable {
      name  = "SAGEMAKER_PROJECT_NAME"
      type  = "PLAINTEXT"
      value = var.project_name
    }
    environment_variable {
      name  = "SAGEMAKER_PROJECT_ID"
      type  = "PLAINTEXT"
      value = var.project_id
    }
    environment_variable {
      name  = "ARTIFACT_BUCKET"
      type  = "PLAINTEXT"
      value = var.artifacts_bucket_name
    }
    environment_variable {
      name  = "MODEL_EXECUTION_ROLE_ARN"
      type  = "PLAINTEXT"
      value = aws_iam_role.tf_mlops_role.arn
    }
    environment_variable {
      name  = "SOURCE_MODEL_PACKAGE_GROUP_NAME"
      type  = "PLAINTEXT"
      value = "${var.project_name}-${var.project_id}"
    }
    environment_variable {
      name  = "AWS_REGION"
      type  = "PLAINTEXT"
      value = var.region
    }
    environment_variable {
      name  = "EXPORT_TEMPLATE_NAME"
      type  = "PLAINTEXT"
      value = "template-export.yml"
    }
    environment_variable {
      name  = "EXPORT_TEMPLATE_STAGING_CONFIG"
      type  = "PLAINTEXT"
      value = "staging-config-export.json"
    }
    environment_variable {
      name  = "EXPORT_TEMPLATE_PROD_CONFIG"
      type  = "PLAINTEXT"
      value = "prod-config-export.json"
    }
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = data.template_file.deploybuildspec.rendered  # connect to buildspec file
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}
