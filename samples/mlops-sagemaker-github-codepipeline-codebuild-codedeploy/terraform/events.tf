resource "aws_cloudwatch_event_rule" "sm_model_registry_rule" {
  name        = "sm-model-registry-event-rule"
  description = "Capture new model registry"

  event_pattern = <<EOF
{
  "source": [
     "aws.sagemaker"
 ],
 "detail-type": [
     "SageMaker Model Package State Change"
 ],
 "detail": {
     "ModelPackageGroupName": ["${var.project_name}-${var.project_id}"    
]
 }
}
EOF
}

resource "aws_cloudwatch_event_target" "sm_model_registry" {
  rule      = aws_cloudwatch_event_rule.sm_model_registry_rule.name
  target_id = "sagemaker-${var.project_name}-registry-trigger"
  arn       = aws_codepipeline.sm_cd_pipeline.arn
  role_arn  = aws_iam_role.tf_mlops_role.arn
}
