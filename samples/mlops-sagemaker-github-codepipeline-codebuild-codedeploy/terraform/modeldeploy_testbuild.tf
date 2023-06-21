resource "aws_codebuild_project" "tf_mlops_testbuild" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "tf-mlops-testbuild"
  queued_timeout = 480
  service_role   = aws_iam_role.tf_mlops_role.arn
  tags = {
    Environment = var.env
  }

  artifacts {
    encryption_disabled    = false
    name                   = "tf-mlops-testbuild-${var.env}"
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
      name  = "AWS_REGION"
      type  = "PLAINTEXT"
      value = var.region
    }
    environment_variable {
      name  = "BUILD_CONFIG"
      type  = "PLAINTEXT"
      value = "staging-config-export.json"
    }
    environment_variable {
      name  = "EXPORT_TEST_RESULTS"
      type  = "PLAINTEXT"
      value = "test-results.json"
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
    buildspec           = "test/test_buildspec.yml"
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
}
