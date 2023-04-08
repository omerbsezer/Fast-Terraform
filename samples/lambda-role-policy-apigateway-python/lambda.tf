terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Create IAM Role for lambda
resource "aws_iam_role" "lambda_role" {
 name   = "aws_lambda_role"
 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy for the lambda
resource "aws_iam_policy" "iam_policy_for_lambda" {

  name         = "aws_iam_policy_for_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Role - Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

# Zipping the code, lambda wants the code as zip file
data "archive_file" "zip_the_python_code" {
 type        = "zip"
 source_dir  = "${path.module}/code/"
 output_path = "${path.module}/code/main.zip"
}

# Lambda Function, in terraform ${path.module} is the current directory.
resource "aws_lambda_function" "lambda_function" {
 filename                       = "${path.module}/code/main.zip"
 function_name                  = "Lambda-Function"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "main.lambda_handler"
 runtime                        = "python3.8"
 depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

# With Lambda permission, API Gateway can invoke Lambda 
resource "aws_lambda_permission" "apigw" {
 statement_id  = "AllowAPIGatewayInvoke"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.lambda_function.function_name
 principal     = "apigateway.amazonaws.com"
 # The "/*/*" portion grants access from any method on any resource within the API Gateway REST API.
 source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}

