resource "aws_codepipeline_webhook" "buildpipeline_webhook" {
  authentication  = "GITHUB_HMAC"
  name            = "codepipeline-webhook"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.sm_ci_pipeline.name  # connect to codepipeline

  authentication_configuration {
    secret_token = random_string.build_github_secret.result
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
  tags = {}
}

resource "github_repository_webhook" "build_github_hook" {
  repository = var.build_repository_name
  events     = ["push"]

  configuration {
    url          = aws_codepipeline_webhook.buildpipeline_webhook.url
    insecure_ssl = "0"
    content_type = "json"
    secret       = random_string.build_github_secret.result
  }
}

resource "random_string" "build_github_secret" {
  length  = 99
  special = false
}
