terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# VPC on which region
provider "aws" {
	region = "eu-central-1"
}

# Creates a new VPC with a CIDR block of 10.0.0.0/16, which allows up to 65,536 IP addresses. DNS hostnames are enabled to allow DNS resolution inside the VPC. 
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "My VPC"
  }
}

# Creates a public subnet within the VPC with a CIDR block of 10.0.0.0/24, which allows up to 256 IP addresses.
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-central-1c"
  tags = {
    Name = "Public Subnet"
  }
}

# Creates an IG and attaches it to the VPC, allowing instances in the VPC to communicate with the internet.
resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

# The route table for the VPC allows all outbound traffic (0.0.0.0/0) to be routed through the internet gateway.
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

# Associates the route table with the public subnet, so the subnet can use the route to access the internet.
resource "aws_route_table_association" "my_vpc_eu_central_1c_public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.my_vpc_eu_central_1c_public.id
}

# This SG is for only test/demo purpose. Please not leave open 22, 3389 for security reason if you have IG, and specific IP isn't defined.
# Port 22 (SSH) for managing Linux instances. Port 80 (HTTP) for web traffic (Apache server). Port 3389 (RDP) for managing Windows instances. ICMP (ping), allowing pings from within the VPC.
# Outbound traffic (egress): All outbound traffic is allowed (0.0.0.0/0).
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
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

# Create Ubuntu instance. The AMI value varies from region to region and from OS to OS.
# SSH Key pair: testkey
# The user data script installs and starts an Apache web server and sets up a simple HTML page with the instance hostname.
resource "aws_instance" "ubuntu2004" {
  ami                         = "ami-0e067cc8a2b58de59" # Ubuntu 20.04 eu-central-1 Frankfurt
  instance_type               = "t2.nano"
  key_name                    = "testkey"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  user_data = <<-EOF
		           #! /bin/bash
                           sudo apt-get update
		           sudo apt-get install -y apache2
		           sudo systemctl start apache2
		           sudo systemctl enable apache2
		           echo "<h1>Deployed via Terraform from $(hostname -f)</h1>" | sudo tee /var/www/html/index.html
  EOF
  tags = {
    Name = "Ubuntu 20.04"
  }
}

resource "aws_instance" "win2019" {
	ami                         = "ami-02c2da541ae36c6fc" # Windows 2019 Server eu-central-1 Frankfurt
	instance_type               = "t2.micro"
        key_name                    = "testkey"
        vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
        subnet_id                   = aws_subnet.public.id  
	associate_public_ip_address = true
        tags = {
		Name = "Win 2019 Server"
	}
}

# Output the public IP addresses of the Ubuntu and Windows EC2 instances
output "instance_ubuntu2004_public_ip" {
  value = "${aws_instance.ubuntu2004.public_ip}"
}

output "instance_win2019_public_ip" {
  value = "${aws_instance.win2019.public_ip}"
}
