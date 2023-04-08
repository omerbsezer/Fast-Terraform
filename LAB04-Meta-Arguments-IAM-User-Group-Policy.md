## LAB-04: Meta Arguments (Count, For_Each, Map) => Provision IAM Users, User Groups, Policies, Attachment Policy-User Group

This scenario shows:
- how to create IAM User, User Groups, Permission Policies, Attachment Policy-User Group
- how to use Count, For_Each, Map

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/labs/iamuser-metaargs-count-for-foreach-map

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

### Count

- Create main.tf under count directory and copy the code:
 
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
``` 

**File:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/iamuser-metaargs-count-for-foreach-map/count/main.tf

![image](https://user-images.githubusercontent.com/10358317/228506487-f1b0f962-9812-4c4a-a189-f88e55ae55f9.png)

- Run init command:

``` 
terraform init
```

- Validate file:

``` 
terraform validate
``` 

![image](https://user-images.githubusercontent.com/10358317/228507230-6a771b36-1bcb-44c5-969f-21640b041a6a.png)

- Run plan command:

``` 
terraform plan
``` 

![image](https://user-images.githubusercontent.com/10358317/229285029-7915460b-24fa-472d-bf32-515d389fdd03.png)

- Run apply command:

``` 
terraform apply
``` 

![image](https://user-images.githubusercontent.com/10358317/229285059-a60d56f4-fe38-43d1-816d-e9537cedf884.png)

![image](https://user-images.githubusercontent.com/10358317/229285114-09358bae-94dc-49b1-bec4-a7951a6bd3d8.png)

- On AWS > IAM > Users, users are created:

![image](https://user-images.githubusercontent.com/10358317/228508807-573a9e39-d906-4ec3-b32a-f1cd57cc5504.png)

- Click on "username1_admin_dev" to see the policies:

![image](https://user-images.githubusercontent.com/10358317/228509359-07dcf4ca-9f2d-422d-9dea-c346f4341168.png)

- To see user groups membership:

![image](https://user-images.githubusercontent.com/10358317/228509893-ed5fc830-94ec-4815-b1be-0811c2e0e566.png)

- Users in the "admin_group":

![image](https://user-images.githubusercontent.com/10358317/228510263-8c6b2b28-20bc-4e86-82a3-8c96c1143b93.png)

- EC2 Policy for "username3_dev_ec2":

![image](https://user-images.githubusercontent.com/10358317/228510983-1458f5f5-275b-4fe2-bc17-84d05bf4cd6c.png)


- Destroy resources:

```
terraform destroy
```

![image](https://user-images.githubusercontent.com/10358317/229285219-a0693f5b-f730-4f09-bcc4-5ddfab11b8b7.png)

### For Each

- To test "for_each", main.tf under for_each.
- Some differents from previous one: 
  - not index, with name. e.g. aws_iam_user.user_example["username1_admin_dev"].name
  - s3 policy, attachment
  - for_each implementation
  
```
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

```
**File:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/iamuser-metaargs-count-for-foreach-map/for_each/main.tf

- This time, for dev groups, it creates S3 Permission Policy

- Run init command:

``` 
terraform init
```

- Validate file:

``` 
terraform validate
``` 

- Run plan command:

``` 
terraform plan
``` 

- Run apply command:

``` 
terraform apply
``` 

![image](https://user-images.githubusercontent.com/10358317/229285279-fe30ddd9-3cec-46c1-88d5-8a504994a956.png)

![image](https://user-images.githubusercontent.com/10358317/228515164-73df4541-e651-40b9-b6d3-068797d7060b.png)

On AWS, the different from previous example, s3 policy is created:

![image](https://user-images.githubusercontent.com/10358317/228515836-b26ef31f-1961-4062-ad0a-73dd40789fff.png)


![image](https://user-images.githubusercontent.com/10358317/228515699-7aabe035-2d17-4140-9c5a-121e72427810.png)

- Destroy resources:

```
terraform destroy
```

![image](https://user-images.githubusercontent.com/10358317/228517742-bfe17919-ce01-4400-a2ac-dade7a041dbd.png)


### Map

- You can also use map to define usernames, following yaml file shows how to use maps

```
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
# With for_each
resource "aws_iam_user" "example" {
  for_each = var.user_names
  name  = each.value
}
# With Map
variable "user_names" {
  description = "map"
  type        = map(string)
  default     = {
    user1      = "username1"
    user2      = "username2"
    user3      = "username3"
  }
}
# with for loop on map 
output "user_with_roles" {
  value = [for name, role in var.user_names : "${name} is the ${role}"]
}
```

**File:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/iamuser-metaargs-count-for-foreach-map/map/main.tf
