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

resource "aws_vpc" "staging-vpc" {
  cidr_block = "10.5.0.0/16"

  tags = {
    Name = "${local.staging_env}-vpc-tag"
  }
}

resource "aws_subnet" "staging-subnet" {
  vpc_id = aws_vpc.staging-vpc.id
  cidr_block = "10.5.0.0/16"

  tags = {
    Name = "${local.staging_env}-subnet-tag"
  }
}

resource "aws_instance" "ec2_example" {
   
   ami           = var.ami
   instance_type = var.instance_type
   subnet_id     = aws_subnet.staging-subnet.id
   
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

# terraform init --var-file="terraform-dev.tfvars"
# terraform plan --var-file="terraform-dev.tfvars"
# terraform apply --var-file="terraform-dev.tfvars"

# terraform init --var-file="terraform-prod.tfvars"
# terraform plan --var-file="terraform-prod.tfvars"
# terraform apply --var-file="terraform-prod.tfvars"
