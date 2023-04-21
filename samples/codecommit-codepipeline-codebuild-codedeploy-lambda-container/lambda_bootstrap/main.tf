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