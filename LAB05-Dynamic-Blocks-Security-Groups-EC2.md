## LAB-05: Dynamic Blocks => Provision Security Groups, EC2, VPC

This scenario shows:
- how to create Dynamic Blocks for Security Group Definition

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/dynamic-blocks/main.tf

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- With Dynamic Blocks, preventing repetition same code. 
 
``` 
...
locals {
   ingress_rules = [{
      port        = 22
      description = "Ingress rules for port SSH"
   },
   {
      port        = 80
      description = "Ingress rules for port HTTP"
   },
   {
      port        = 443
      description = "Ingress rules for port HTTPS"
   }]
}

resource "aws_security_group" "main" {
   ...
   dynamic "ingress" {
      for_each = local.ingress_rules

      content {
         description = ingress.value.description
         from_port   = ingress.value.port
         to_port     = ingress.value.port
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
   }
   ...
}
...
``` 

![image](https://user-images.githubusercontent.com/10358317/229287304-d23dca31-d871-4c88-a4fa-e1994ef671d0.png)

- Copy the following main.tf:
 
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
	region = "eu-central-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-central-1c"
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "my_vpc_eu_central_1c_public" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }
    tags = {
        Name = "Public Subnet Route Table"
    }
}
resource "aws_route_table_association" "my_vpc_eu_central_1c_public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.my_vpc_eu_central_1c_public.id
}

locals {
   ingress_rules = [{
      port        = 22
      description = "Ingress rules for port SSH"
   },
   {
      port        = 80
      description = "Ingress rules for port HTTP"
   },
   {
      port        = 443
      description = "Ingress rules for port HTTPS"
   }]
}

resource "aws_security_group" "main" {
   name        = "resource_with_dynamic_block"
   description = "Allow SSH inbound connections"
   vpc_id      =  aws_vpc.my_vpc.id 

   dynamic "ingress" {
      for_each = local.ingress_rules

      content {
         description = ingress.value.description
         from_port   = ingress.value.port
         to_port     = ingress.value.port
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
   }

   egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
   }

   tags = {
      Name = "AWS security group dynamic block"
   }
}

resource "aws_instance" "ubuntu2204" {
  ami                         = "ami-0d1ddd83282187d18" # Ubuntu 22.04 eu-central-1 Frankfurt
  instance_type               = "t2.nano"
  key_name                    = "testkey"
  vpc_security_group_ids      = [aws_security_group.main.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  tags = {
    Name = "Ubuntu 22.04"
  }
}

output "instance_ubuntu2204_public_ip" {
  value = "${aws_instance.ubuntu2204.public_ip}"
}
``` 

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/dynamic-blocks/main.tf

- Run init, validate command:

``` 
terraform init
terraform validate
``` 

- Run plan, apply command:

``` 
terraform plan
terraform apply
``` 

![image](https://user-images.githubusercontent.com/10358317/229287533-de896cdf-6189-45f1-a631-5f609be22721.png)

![image](https://user-images.githubusercontent.com/10358317/229287613-9815134c-4e36-4d70-adff-c7a272d82a31.png)

- On AWS EC2 Instances:

![image](https://user-images.githubusercontent.com/10358317/229287673-ddbfa4a9-ca15-4375-a584-043cf259d344.png)

- Security groups are created with Dynamic Blocks:

![image](https://user-images.githubusercontent.com/10358317/229287707-b5f215cd-0faf-4cbc-bc1d-868d96f2672d.png)

- Destroy infrastructure:

```
terraform destroy 
``` 

![image](https://user-images.githubusercontent.com/10358317/229287838-c3ffcaa2-a931-4c9b-9efe-40760d76a6af.png)

![image](https://user-images.githubusercontent.com/10358317/229287904-a2ff9428-f15b-4b2e-a2fb-749d11f4e317.png)
