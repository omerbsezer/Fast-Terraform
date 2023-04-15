# Internet Access -> IGW ->  Route Table -> Subnets
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

resource "aws_subnet" "public_subnet_a" {
  availability_zone = "eu-central-1a"
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "public_subnet_b" {
  availability_zone = "eu-central-1b"
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "Public Subnet B"
  }
}

resource "aws_subnet" "public_subnet_c" {
  availability_zone = "eu-central-1c"
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "Public Subnet C"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Public Subnet Route Table"
    }
}

resource "aws_route_table_association" "route_table_association1" {
    subnet_id      = aws_subnet.public_subnet_a.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association2" {
    subnet_id      = aws_subnet.public_subnet_b.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association3" {
    subnet_id      = aws_subnet.public_subnet_c.id
    route_table_id = aws_route_table.route_table.id
}