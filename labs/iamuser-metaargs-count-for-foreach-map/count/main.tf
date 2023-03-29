# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
# IAM users - roles - permissions
# User         -> User Group -> Policy (Permission)
# AWS Services -> Roles      -> Policy (Permission)
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
  user = aws_iam_user.user_example[0].name

  groups = [
    aws_iam_group.admin_group.name,
    aws_iam_group.dev_group.name,
  ]
}

resource "aws_iam_user_group_membership" "user2_group_attach" {
  user = aws_iam_user.user_example[1].id

  groups = [
    aws_iam_group.admin_group.name
  ]
}

resource "aws_iam_user_group_membership" "user3_group_attach" {
  user = aws_iam_user.user_example[2].name

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

data "aws_iam_policy_document" "ec2_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2-policy"
  description = "EC2 policy"
  policy      = data.aws_iam_policy_document.ec2_policy.json
}

#####################################################
# Policy Attachment to the Admin, Dev Group 
resource "aws_iam_group_policy_attachment" "admin_group_admin_policy_attach" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_iam_group_policy_attachment" "dev_group_ec2_policy_attach" {
  group      = aws_iam_group.dev_group.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

#####################################################
# Username Definition
# With Count
resource "aws_iam_user" "user_example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}
# count, use list 
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["username1_admin_dev", "username2_admin", "username3_dev_ec2"]
}
#####################################################
# With for loop
output "print_the_names" {
  value = [for name in var.user_names : name]
}
