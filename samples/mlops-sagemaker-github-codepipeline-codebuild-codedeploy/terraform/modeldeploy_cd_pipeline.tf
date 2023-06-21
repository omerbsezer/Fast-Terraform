#data "aws_caller_identity" "current" {}
resource "aws_codepipeline" "sm_cd_pipeline" {
  name     = "modeldeploy-pipeline"
  role_arn = aws_iam_role.tf_mlops_role.arn
  tags = {
    Environment = var.env
  }

  artifact_store {
    location = aws_s3_bucket.artifacts_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "Branch"               = var.repository_branch
        "Owner"                = var.repository_owner
        "PollForSourceChanges" = "false"
        "Repo"                 = var.deploy_repository_name
        OAuthToken             = var.github_token
      }

      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "ThirdParty"
      provider  = "GitHub"
      run_order = 1
      version   = "1"
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = "tf-mlops-deploybuild"  # connect to codebuild, alternative: aws_codebuild_project.tf_mlops_deploybuild.name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }

  stage {
    name = "DeployStaging"

    action {
      category = "Deploy"
      configuration = {
        "ActionMode": "REPLACE_ON_FAILURE",
        "Capabilities": "CAPABILITY_NAMED_IAM",
        "RoleArn": aws_iam_role.tf_mlops_role.arn,
        "StackName": "sagemaker-${var.project_name}-${var.project_id}-deploy-staging",
        "TemplateConfiguration": "BuildArtifact::staging-config-export.json",
        "TemplatePath": "BuildArtifact::template-export.yml"

      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name = "DeployResourcesStaging"
      owner     = "AWS"
      provider  = "CloudFormation"
      run_order = 1
      version   = "1"
    }

    action {
      category = "Build"
      configuration = {
        "ProjectName" = "tf-mlops-testbuild",  # connect to codebuild, alternative: aws_codebuild_project.tf_mlops_testbuild.name
        "PrimarySource" = "SourceArtifact"
      }
      input_artifacts = [
        "SourceArtifact","BuildArtifact"
      ]
      name = "TestStaging"
      output_artifacts = [
        "TestArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 2
      version   = "1"
    }

    action {
      category = "Approval"
      configuration = {
        "CustomData"= "Approve this model for Production"
      }
      name = "ApproveDeployment"
      owner     = "AWS"
      provider  = "Manual"
      run_order = 3
      version   = "1"
    }
  }
  stage {
    name = "DeployProd"

    action {
      category = "Deploy"
      configuration = {
        "ActionMode": "CREATE_UPDATE",
        "RoleArn": aws_iam_role.tf_mlops_role.arn,
        "Capabilities": "CAPABILITY_NAMED_IAM",
        "StackName": "sagemaker-${var.project_name}-${var.project_id}-deploy-prod",
        "TemplateConfiguration": "BuildArtifact::prod-config-export.json",
        "TemplatePath": "BuildArtifact::template-export.yml"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name = "DeployResourcesProd"
      owner     = "AWS"
      provider  = "CloudFormation"
      run_order = 1
      version   = "1"
    }
  }

}
