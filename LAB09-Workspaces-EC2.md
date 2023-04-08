## LAB-09: Workspaces => Provision EC2 with Different tfvars Files

This scenario shows:
- how to create, manage workspaces using EC2 and variables.

**Code:**  https://github.com/omerbsezer/Fast-Terraform/tree/main/labs/workspace

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- With workspaces,
  - a parallel, distinct copy of your infrastructure which you can test and verify in the development, test, and staging 
  - like git, you are working on different workspaces (like branch)
  - single code but different workspaces
  - it creates multiple state files

- Workspace commands:

``` 
terraform workspace help                       # help for workspace commands
terraform workspace new [WorkspaceName]        # create new workspace
terraform workspace select [WorkspaceName]     # change/select another workspace
terraform workspace show                       # show current workspace
terraform workspace list                       # list all workspaces
terraform workspace delete [WorkspaceName]     # delete existed workspace
``` 

![image](https://user-images.githubusercontent.com/10358317/229855095-05b608f7-04aa-4603-9516-600d0c692d01.png)

- We have basic main.tf file with EC2, variables:

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

provider "aws" {
	region = var.location
}

locals {
    tag = "${terraform.workspace} EC2"
}

resource "aws_instance" "instance" {
	ami           = var.ami
	instance_type = var.instance_type

	tags = {
		Name = local.tag
	}
}
``` 

**Code:**  https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/workspace/main.tf

![image](https://user-images.githubusercontent.com/10358317/230614196-cd007efe-388e-408b-a92e-bb064e07e0ab.png)

- Variables.tf file:

```
variable "instance_type" {
    type = string
    description = "EC2 Instance Type"
}

variable "location" {
    type = string
    description = "The project region"
    default = "eu-central-1"
}

variable "ami" {
    type = string
    description = "The project region"
}
```

**Code:**  https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/workspace/variables.tf

![image](https://user-images.githubusercontent.com/10358317/230614240-504aaebd-00a5-4d85-8ecd-73df9a9a2254.png)

- For development workspace, terraform-dev.tfvars:

```
instance_type     =   "t2.nano"
location          =   "eu-central-1"
ami               =   "ami-0e067cc8a2b58de59" # Ubuntu 20.04 eu-central-1 Frankfurt
```

**Code:**  https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/workspace/terraform-dev.tfvars

![image](https://user-images.githubusercontent.com/10358317/230614271-f5c5ccde-3d29-40ae-845f-5260060e2a5c.png)


- For product workspace, terraform-prod.tfvars:

```
instance_type     =   "t2.micro"
location          =   "eu-central-1"
ami               =   "ami-0d1ddd83282187d18" # Ubuntu 22.04 eu-central-1 Frankfurt
```

**Code:**  https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/workspace/terraform-prod.tfvars

![image](https://user-images.githubusercontent.com/10358317/230614321-0f2ba768-cc0d-44f6-b68f-8a5c94ccb976.png)

- To list current workspaces on the local:

```
terraform workspace list
```

![image](https://user-images.githubusercontent.com/10358317/230609965-a282fba2-d318-4a24-b189-c928abdbd2cf.png)

- 2 workspaces are created (DEV, PROD):

```
terraform workspace new dev
terraform workspace new prod
terraform workspace list
```

![image](https://user-images.githubusercontent.com/10358317/230610099-3b8e3d91-e0a9-4a4e-bb25-8a8e15a489b5.png)

- Switch to DEV workspace, show current workspace and initialize terraform:

```
terraform workspace select dev
terraform workspace show
terraform init
```

![image](https://user-images.githubusercontent.com/10358317/230610877-e76ed796-6e38-4493-89d7-2dbdbd43457f.png)

- Create infrastructure in DEV workspace: 

```
terraform plan -var-file="terraform-dev.tfvars"     # for test, dry-run
terraform apply -var-file="terraform-dev.tfvars"
```

- On AWS, it creates dev EC2:

![image](https://user-images.githubusercontent.com/10358317/230612063-b66afd1e-749a-41fe-b899-c68933ad4aa8.png)


- Switch to PROD workspace, create infrastructure in PROD workspace: 

```
terraform workspace select prod
terraform plan -var-file="terraform-prod.tfvars"     # for test, dry-run
terraform apply -var-file="terraform-prod.tfvars"
```

![image](https://user-images.githubusercontent.com/10358317/230612548-c8b79323-7f28-43c2-adc7-c7874ad3ed90.png)

- On AWS, it creates prod EC2:

![image](https://user-images.githubusercontent.com/10358317/230612752-565fdef3-7f89-496c-b108-03d6d38008ef.png)

- With workspace, 2 state files are created for each workspace:

![image](https://user-images.githubusercontent.com/10358317/230612889-dcd95404-3b0c-4b35-a3e4-a7844ca54a86.png)


- Switch to DEV workspace, destroy infrastructure only in DEV workspace: 

```
terraform workspace select dev
terraform destroy -var-file="terraform-dev.tfvars"  
```

![image](https://user-images.githubusercontent.com/10358317/230613305-4bfe6f81-e1bb-41c6-88cd-3ba9a37ee519.png)

- On AWS, ONLY dev EC2 is terminated:

![image](https://user-images.githubusercontent.com/10358317/230613441-3e52a33d-6721-47bf-a72e-1b28e524aac9.png)


- Switch to PROD workspace, destroy infrastructure only in PROD workspace: 

```
terraform workspace select prod
terraform destroy -var-file="terraform-prod.tfvars"  
```

![image](https://user-images.githubusercontent.com/10358317/230613867-c347eb16-6f5d-452c-85cf-4e54d3dfc89f.png)

- On AWS, ONLY prod EC2 is terminated:

![image](https://user-images.githubusercontent.com/10358317/230613937-92d8ec9c-ffd2-48f7-9cbd-be6ca11500b5.png)


## References
- https://jhooq.com/terraform-workspaces/




