terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
	region = "eu-central-1"
}

resource "aws_iam_user" "newuser" {
  name = "New-User"     # must only contain alphanumeric characters, hyphens, underscores, commas, periods, @ symbols, plus and equals signs
}
resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.newuser.name
}

resource "aws_iam_user_policy" "instanceManageUser_assume_role" {
  name = "EC2-S3-Lambda-DynamoDb-Policy"
  user = "${aws_iam_user.newuser.name}"
  policy = templatefile("${path.module}/policy.tftpl", {
    ec2_policies = [
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:StartInstances",
      "ec2:TerminateInstances",
      "ec2:TerminateInstances",
      "ec2:Describe*",
      "ec2:CreateTags",
      "ec2:RequestSpotInstances"
    ],
    s3_policies = [
      "s3:Get*",
      "s3:List*",
      "s3:Describe*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"
    ],
    lambda_policies = [
      "lambda:Create*",
      "lambda:List*",
      "lambda:Delete*",
      "lambda:Get*"
    ],
    dynamodb_policies = [
      "dynamodb:Describe*",
      "dynamodb:Update*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:PartiQLSelect"
    ],
  })
}

output "secret_key" {
  value = aws_iam_access_key.access_key.secret
  sensitive = true
}

output "access_key" {
  value = aws_iam_access_key.access_key.id
}