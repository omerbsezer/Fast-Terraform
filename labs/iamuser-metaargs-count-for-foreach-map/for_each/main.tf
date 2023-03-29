# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
# IAM users - roles - permissions
# User         -> User Group -> Policy (Permission)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

#####################################################
# User - User Group Attachment (With Index Count)
resource "aws_iam_user_group_membership" "user1_group_attach" {
  user = aws_iam_user.user_example["username1_admin_dev"].name

  groups = [
    aws_iam_group.admin_group.name,
    aws_iam_group.dev_group.name,
  ]
}

resource "aws_iam_user_group_membership" "user2_group_attach" {
  user = aws_iam_user.user_example["username2_admin"].id

  groups = [
    aws_iam_group.admin_group.name
  ]
}

resource "aws_iam_user_group_membership" "user3_group_attach" {
  user = aws_iam_user.user_example["username3_dev_s3"].name

  groups = [
    aws_iam_group.dev_group.name
  ]
}
#####################################################
# User Group Definition
resource "aws_iam_group" "admin_group" {
  name = "admin_group"
}

resource "aws_iam_group" "dev_group" {
  name = "dev_group"
}
#####################################################
# Policy Definition, Policy-Group Attachment
data "aws_iam_policy_document" "admin_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "admin_policy" {
  name        = "admin-policy"
  description = "Admin policy"
  policy      = data.aws_iam_policy_document.admin_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = [
      "arn:aws:s3:::mybucket",
      "arn:aws:s3:::mybucket/*"
    ]
  }
}

resource "aws_iam_policy" "s3_policy" {
  name        = "s3-policy"
  description = "S3 policy"
  policy      = data.aws_iam_policy_document.s3_policy.json
}

#####################################################
# Policy Attachment to the Admin, Dev Group 
resource "aws_iam_group_policy_attachment" "admin_group_admin_policy_attach" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_iam_group_policy_attachment" "dev_group_s3_policy_attach" {
  group      = aws_iam_group.dev_group.name
  policy_arn = aws_iam_policy.s3_policy.arn
}
#####################################################
# With for_each
resource "aws_iam_user" "user_example" {
  for_each = var.user_names
  name  = each.value
}
# for each, use set instead of list
variable "user_names" {
  description = "IAM usernames"
  type        = set(string)
  default     = ["username1_admin_dev", "username2_admin", "username3_dev_s3"]
}
#####################################################
# With for loop
output "print_the_names" {
  value = [for name in var.user_names : name]
}
