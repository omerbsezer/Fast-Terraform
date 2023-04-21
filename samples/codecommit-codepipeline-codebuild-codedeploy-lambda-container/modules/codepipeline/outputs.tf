output "codepipeline_configs" {
    value = {
        codepipeline = aws_codepipeline.codepipeline.arn
    }
}
output "deployment_role_arn" {
    value = aws_iam_role.lambda_codebuild_role.arn
}