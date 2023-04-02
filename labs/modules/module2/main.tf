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
  staging_env = "module2"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.5.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${local.staging_env}-vpc-tag"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.5.0.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "${local.staging_env}-subnet-tag"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.staging_env}-Internet Gateway"
  }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${local.staging_env}- Public Subnet Route Table"
    }
}
resource "aws_route_table_association" "rta" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "ssg" {
  name        = "module2_security_group"    # name should be different on modules
  description = "Allow SSH inbound connections"
  vpc_id      = aws_vpc.my_vpc.id
  # for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # for HTTP Apache Server
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # for HTTPS Apache Server
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh_sg"
  }
}

resource "aws_instance" "ec2" {
   ami                         = var.ami
   instance_type               = var.instance_type
   subnet_id                   = aws_subnet.public.id
   associate_public_ip_address = true
   vpc_security_group_ids      = [aws_security_group.ssg.id]
   user_data = <<-EOF
		           #! /bin/bash
                           sudo apt-get update
		           sudo apt-get install -y apache2
		           sudo systemctl start apache2
		           sudo systemctl enable apache2
		           echo "<h1>** MODULE-2 **:  Deployed via Terraform from $(hostname -f)</h1>" | sudo tee /var/www/html/index.html
  EOF
  tags = {
    Name = var.tag
  }
  
}

# output single values
output "public_ip" {
  value = aws_instance.ec2.public_ip
}

