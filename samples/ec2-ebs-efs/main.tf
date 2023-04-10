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

resource "aws_security_group" "sg_config" {
  name        = "allow_ssh_sg"
  description = "Allow SSH inbound connections"
  vpc_id      = aws_vpc.my_vpc.id
  # for SSH
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  # for HTTP Apache Server
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  # for RDP
  ingress {
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  # for ping
  ingress {
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["10.0.0.0/16"]
  }
  # EFS mount target, important to connect with NFS file system, it must be added.
  ingress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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

resource "aws_instance" "ubuntu2004" {
  ami                         = "ami-0e067cc8a2b58de59" # Ubuntu 20.04 eu-central-1 Frankfurt
  instance_type               = "t2.nano"
  key_name                    = "testkey"
  vpc_security_group_ids      = [aws_security_group.sg_config.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  tags = {
    Name = "Ubuntu 20.04"
  }
}

resource "aws_instance" "win2019" {
  ami                         = "ami-02c2da541ae36c6fc" # Windows 2019 Server eu-central-1 Frankfurt
  instance_type               = "t2.micro"
  key_name                    = "testkey"
  vpc_security_group_ids      = [aws_security_group.sg_config.id]
  subnet_id                   = aws_subnet.public.id  
  associate_public_ip_address = true
  tags = {
    Name = "Win 2019 Server"
  }
}

output "instance_ubuntu2004_public_ip" {
  value = "${aws_instance.ubuntu2004.public_ip}"
}

output "instance_win2019_public_ip" {
  value = "${aws_instance.win2019.public_ip}"
}

