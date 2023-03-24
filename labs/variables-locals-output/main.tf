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

# terraform init 

# terraform plan --var-file="terraform-dev.tfvars"
# terraform apply --var-file="terraform-dev.tfvars"
# terraform destroy --var-file="terraform-dev.tfvars"

# terraform plan --var-file="terraform-prod.tfvars"
# terraform apply --var-file="terraform-prod.tfvars"
# terraform destroy --var-file="terraform-prod.tfvars"