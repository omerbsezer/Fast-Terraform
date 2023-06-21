data "template_file" "buildspec" {
  template = file("modelbuild_buildspec.yml")  # connect to buildspec file
  vars = {
    env = var.env
    SAGEMAKER_PROJECT_NAME=var.project_name
    SAGEMAKER_PROJECT_ID=var.project_id
    ARTIFACT_BUCKET=var.artifacts_bucket_name
    SAGEMAKER_PIPELINE_ROLE_ARN=aws_iam_role.tf_mlops_role.arn
    AWS_REGION=var.region
    SAGEMAKER_PROJECT_NAME_ID="${var.project_name}-${var.project_id}"
  }
}

resource "aws_codebuild_project" "tf_mlops_modelbuild" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "tf-mlops-modelbuild"
  queued_timeout = 480
  service_role   = aws_iam_role.tf_mlops_role.arn
  tags = {
    Environment = var.env
  }

  artifacts {
    encryption_disabled    = false
    name                   = "tf-mlops-modelbuild-${var.env}"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
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
      name  = "SAGEMAKER_PIPELINE_ROLE_ARN"
      type  = "PLAINTEXT"
      value = aws_iam_role.tf_mlops_role.arn
    }
    environment_variable {
      name  = "AWS_REGION"
      type  = "PLAINTEXT"
      value = var.region
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
    buildspec           = data.template_file.buildspec.rendered  # connect to buildspec file
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}
