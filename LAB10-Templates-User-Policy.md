## LAB-10: Templates => Provision IAM User, User Access Key, Policy

This scenario shows:
- how to use templates while creating policy 

**Code:**  https://github.com/omerbsezer/Fast-Terraform/tree/main/labs/template

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- With templates,
  - avoid to write same code snippets multiple time,
  - provide to shorten the code 

- Create main.tf file.
- This file creates IAM user, user access key, give some permission policy for EC2, S3, Lambda, DynamoDb. 

```
# main.tf
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
``` 

**Code:**  https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/template/main.tf

![image](https://user-images.githubusercontent.com/10358317/230635156-50072817-9f9c-428a-906f-ebfe77e4f3ae.png)


- Template file => Policy.tftpl:

``` 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ${jsonencode(ec2_policies)},
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": ${jsonencode(s3_policies)},
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": ${jsonencode(lambda_policies)},
            "Resource": "*"
        },
         {
            "Effect": "Allow",
            "Action": ${jsonencode(dynamodb_policies)},
            "Resource": "*"
        }
    ]
}
```

**Code:**  https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/template/policy.tftpl

![image](https://user-images.githubusercontent.com/10358317/230635437-a2833841-b6be-4a2d-8c7b-a89c1d60c9ad.png)

- Run init, validate command:

``` 
terraform init
terraform validate
``` 

![image](https://user-images.githubusercontent.com/10358317/230635918-74679513-1e33-4348-9b82-5b7ee631d7e5.png)

- Run plan, apply command:

``` 
terraform plan   # for dry-run
terraform apply
``` 

![image](https://user-images.githubusercontent.com/10358317/230636213-a285546a-7f38-4c04-bdb7-81254be09654.png)

![image](https://user-images.githubusercontent.com/10358317/230636709-d2f2115f-54f1-4e1c-9075-9e035f4ca15a.png)

- On AWS IAM:

![image](https://user-images.githubusercontent.com/10358317/230636965-74714983-435a-4009-a015-1117032c5815.png)

![image](https://user-images.githubusercontent.com/10358317/230637038-235ad9fa-6f03-434b-a1df-15b38b218b19.png)


- Run destroy command to delete user:

``` 
terraform destroy
``` 

![image](https://user-images.githubusercontent.com/10358317/230637447-5f1eb783-3a8f-45cc-afb6-522e27d74a9a.png)

