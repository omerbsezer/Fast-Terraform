## LAB-03: Variables, Locals, Output => Provision EC2s

This scenario shows:
- how to create EC2 using Variables, Locals and Output

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/labs/variables-locals-output

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- Create main.tf and copy the code:
 
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
   region     = var.location
}

locals {
  staging_env = "staging"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${local.staging_env}-vpc-tag"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/16"
  availability_zone = var.availability_zone
  tags = {
    Name = "${local.staging_env}-subnet-tag"
  }
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.staging_env}-Internet Gateway"
  }
}

resource "aws_route_table" "my_vpc_eu_central_1c_public" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }
    tags = {
        Name = "${local.staging_env}- Public Subnet Route Table"
    }
}
resource "aws_route_table_association" "my_vpc_eu_central_1c_public" {
    subnet_id      = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.my_vpc_eu_central_1c_public.id
}

resource "aws_instance" "ec2_example" {
   
   ami                         = var.ami
   instance_type               = var.instance_type
   subnet_id                   = aws_subnet.my_subnet.id
   associate_public_ip_address = true
   
   tags = {
           Name = var.tag
   }
}

# output single values
output "public_ip" {
  value = aws_instance.ec2_example.public_ip
}

# output single values
output "public_dns" {
  value = aws_instance.ec2_example.public_dns
} 

# output multiple values
output "instance_ips" {
  value = {
    public_ip  = aws_instance.ec2_example.public_ip
    private_ip = aws_instance.ec2_example.private_ip
  }
} 
```
- Code: https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/variables-locals-output/main.tf

![image](https://user-images.githubusercontent.com/10358317/227576390-d65cfefb-ac47-4873-9b49-31774174d2d8.png)


- Create variables.tf:
```
variable "instance_type" {
    type = string
    description = "EC2 Instance Type"
}

variable "tag" {
    type = string
    description = "The tag for the EC2 instance"
}

variable "location" {
    type = string
    description = "The project region"
    default = "eu-central-1"
}

variable  "availability_zone" {
    type = string
    description = "The project availability zone"
    default = "eu-central-1c"
} 

variable "ami" {
    type = string
    description = "The project region"
}
```
- Code: https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/variables-locals-output/variables.tf

![image](https://user-images.githubusercontent.com/10358317/227576884-4a6d5052-cc5b-47e7-bd9f-30d5955bdcda.png)

- Create terraform-dev.tfvars:

```
 instance_type     =   "t2.nano"
 tag               =   "EC2 Instance for DEV"
 location          =   "eu-central-1"
 availability_zone =   "eu-central-1c"
 ami               =   "ami-0e067cc8a2b58de59" # Ubuntu 20.04 eu-central-1 Frankfurt
```
- Code: https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/variables-locals-output/terraform-dev.tfvars

![image](https://user-images.githubusercontent.com/10358317/227577004-107a8d30-b137-43bc-835c-74c3ce27117d.png)

- Create terraform-prod.tfvars:

```
instance_type     =   "t2.micro"
tag               =   "EC2 Instance for PROD"
location          =   "eu-central-1"
availability_zone =   "eu-central-1c"
ami               =   "ami-0d1ddd83282187d18" # Ubuntu 22.04 eu-central-1 Frankfurt
```
- Code: https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/variables-locals-output/terraform-prod.tfvars

![image](https://user-images.githubusercontent.com/10358317/227577134-e6023e7a-7d54-4406-ae8a-97bf3e89e9fe.png)

- Run init command:

``` 
terraform init
``` 

![image](https://user-images.githubusercontent.com/10358317/227567351-655c2233-a5fd-4fea-a9d2-ddcc32f12d0e.png)


- Validate file:

``` 
terraform validate
``` 

![image](https://user-images.githubusercontent.com/10358317/227567482-7592f836-5d61-46c7-8467-0bc36fc6e852.png)

- Run plan command with DEV tfvar file:

``` 
terraform plan --var-file="terraform-dev.tfvars"
``` 

![image](https://user-images.githubusercontent.com/10358317/227568275-14f0bdd6-20b7-450e-8f19-383a7c36a629.png)

- Run apply command to create resources, with DEV tfvar file. Then, Terraform asks to confirm, write "yes":

``` 
terraform apply --var-file="terraform-dev.tfvars"
```  

![image](https://user-images.githubusercontent.com/10358317/227573622-460f5970-612f-49ed-bcaa-cfeecd9d2c49.png)

![image](https://user-images.githubusercontent.com/10358317/229284493-13646f69-5e8d-4dc0-aa21-6d6149b8acb3.png)

- On AWS EC2 Instances:

![image](https://user-images.githubusercontent.com/10358317/227574209-11e89611-4776-4fc0-a76d-80c56a263c71.png)

- On VPC Section:

![image](https://user-images.githubusercontent.com/10358317/227575010-944ff35b-47a8-4caf-81e8-46e4d7089d4a.png)

- Destroy DEV Environment:

```
terraform destroy --var-file="terraform-dev.tfvars"
```

![image](https://user-images.githubusercontent.com/10358317/229284618-506f4daf-70c7-4411-b399-9e865b4d81a1.png)

![image](https://user-images.githubusercontent.com/10358317/229284719-ac78448b-7386-4fe8-afcc-8f3a6ae6edc8.png)

- Update locals for PROD in main.tf:

```
....
locals {
  staging_env = "product"
}
.....
```

![image](https://user-images.githubusercontent.com/10358317/227581270-6cdba303-e29c-486e-abf3-831529a459b9.png)

- Run plan command with PROD tfvar file:

``` 
terraform plan --var-file="terraform-prod.tfvars"
``` 

![image](https://user-images.githubusercontent.com/10358317/227578564-ff43db34-2e35-45d8-bffa-f5d132dd0967.png)

- Run apply command to create resources, with PROD tfvar file. Then, Terraform asks to confirm, write "yes":

``` 
terraform apply --var-file="terraform-prod.tfvars"
```  

![image](https://user-images.githubusercontent.com/10358317/227578878-4d3e2d4c-2878-4b90-8751-246598748da6.png)


- On AWS EC2 Instances:

![image](https://user-images.githubusercontent.com/10358317/227579473-a9f883ee-28d7-4a39-9647-6371712303ea.png)

- On VPC Section:

![image](https://user-images.githubusercontent.com/10358317/227579952-e70efbd3-0d42-46b7-b661-ad7b4f9ba41e.png)


- Destroy PROD Environment:

```
terraform destroy --var-file="terraform-prod.tfvars"
```

![image](https://user-images.githubusercontent.com/10358317/229284826-cbaf8761-e960-44ed-867d-3b1f6e3ae88f.png)

![image](https://user-images.githubusercontent.com/10358317/229284932-f216c36c-235d-4511-8510-11f613321422.png)

- On EC2 Instances, all instances are terminated:

![image](https://user-images.githubusercontent.com/10358317/227580749-328c2a30-ae0c-441f-9fa0-e40f20fa818b.png)

