## SAMPLE-01: Provisioning EC2s (Windows 2019 Server, Ubuntu 20.04) on VPC (Subnet), Creating Key-Pair, Connecting Ubuntu using SSH, and Connecting Windows Using RDP

This sample shows:
- how to create Key-pairs (public and private keys) on AWS.
- how to create EC2s (Ubuntu 20.04, Windows 2019 Server).
- how to create Virtual Private Cloud (VPC), VPC Components (Public Subnet, Internet Gateway, Route Table) and link to each others.
- how to create Security Groups (for SSH and Remote Desktop).

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/ec2-vpc-ubuntu-win-ssh-rdp

  ![1 VPC-IG-EC2](https://github.com/user-attachments/assets/29c5a207-bc35-43f1-8c4e-75d77acf77c1)

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- SSH key-pairs (public and private key) are used to connect remote server. Public key (xx.pub) is on the remote server, with private key, user can connect using SSH.

- There are 2 ways of creating key-pairs (public and private key):
  - Creating them on cloud (AWS)
  	- EC2 > Key-pairs > Create Key-Pair
  - Creating them on on-premise 
  	- "ssh-keygen -t rsa -b 2048" 

- Creating key-pairs on AWS: Go to EC2 > Key-pairs

![image](https://user-images.githubusercontent.com/10358317/228974087-b57126ab-6589-48fe-b609-1f18dc2f0c7e.png)

- After creating key-pairs, public key is listed on AWS:

![image](https://user-images.githubusercontent.com/10358317/228974292-0d2d16ec-5590-4929-9b4e-8bc0215dcd60.png)

- Private key (testkey.pem) is downloaded on your PC:

![image](https://user-images.githubusercontent.com/10358317/228974369-46c54f25-ea80-40dd-9c75-670ece815bf2.png)

- Copy this testkey.pem into your directory on which main.tf exists.

![image](https://user-images.githubusercontent.com/10358317/228974784-de1b9be4-9083-45ec-a9ab-5a1e54aee2c5.png)


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

output "instance_ubuntu2004_public_ip" {
  value = "${aws_instance.ubuntu2004.public_ip}"
}

output "instance_win2019_public_ip" {
  value = "${aws_instance.win2019.public_ip}"
}
``` 

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ec2-vpc-ubuntu-win-ssh-rdp/main.tf

![image](https://user-images.githubusercontent.com/10358317/228973324-4bc1c6ad-1099-4f56-8e6f-c002f719d9d4.png)

- Run init command:

``` 
terraform init
``` 

![image](https://user-images.githubusercontent.com/10358317/228975022-6ed0663d-dca8-427b-8a9b-7cce25522117.png)

- Validate file:

``` 
terraform validate
``` 

![image](https://user-images.githubusercontent.com/10358317/228975088-077a0562-ee85-4ad2-8cc9-2f4ccd1c4c94.png)


- Run plan command:

``` 
terraform plan
``` 

- Run apply command to create resources. Then, Terraform asks to confirm, write "yes":

``` 
terraform apply
```

![image](https://user-images.githubusercontent.com/10358317/228975493-a28ece3e-b00d-436e-aab1-de7b679378f3.png)

![image](https://user-images.githubusercontent.com/10358317/229282068-a4f293cf-cde7-4b6b-9e9e-48bd40822aae.png)

- On AWS EC2 > Instances, Ubuntu 20.04:

![image](https://user-images.githubusercontent.com/10358317/228975962-72c0fbe9-e1dc-482c-8edc-573013424953.png)

- Security groups (SSG), for SSH (port 22), RDP (port 3389), HTTP (80), ICMP (for ping):

![image](https://user-images.githubusercontent.com/10358317/228976204-c4993141-c8ad-4110-8f05-c1fb1e2c13c2.png)

![image](https://user-images.githubusercontent.com/10358317/228976348-f07e284e-be34-4898-9b81-92a756910a56.png)

- On AWS EC2 > Instances, Window 2019 Server:

![image](https://user-images.githubusercontent.com/10358317/228976557-7951b759-73fd-46a6-b325-08389e52b86f.png)

- Windows has same SSG like Ubuntu.

- Storage, Elastic Block Storage default:

![image](https://user-images.githubusercontent.com/10358317/228976823-4e80c3e5-8ec6-4e4b-b5d2-aa064982954d.png)

- On AWS VPC (Virtual Private Cloud) Service:

![image](https://user-images.githubusercontent.com/10358317/228977082-f0634c8e-8701-45e2-aa22-f0b7dc1e3400.png)

- While installing Ubuntu20.04, userdata is used to install Apache Server on it. With SSG Port 80, using public IP, we can see the index.html, like hosting server:

![image](https://user-images.githubusercontent.com/10358317/228978767-aee0b725-eff2-40b2-8a30-93f40c15a052.png)


- SSH to Ubuntu 20.04 (ssh -i testkey.pem ubuntu@<PublicIPAddress>):

![image](https://user-images.githubusercontent.com/10358317/228977324-3393ae14-85d8-48ba-9133-bc7a6f1ef73b.png)

- Run:
  
```   
sudo apt install net-tools
ifconfig 
``` 

- Private IP can be seen:
  
![image](https://user-images.githubusercontent.com/10358317/228977710-610437ee-c1c2-4a7e-82e7-ac07d38aed62.png)

- Make remote connection to Windows (RDP):
  
![image](https://user-images.githubusercontent.com/10358317/228977887-14d82ad9-41ff-43eb-bdaf-2c3e007df506.png)

- Download RDP App:
  
![image](https://user-images.githubusercontent.com/10358317/228978036-79956ff6-755e-4205-aa17-4ac45f8e6642.png)
  
- To get password, upload testkey.pem file:
  
![image](https://user-images.githubusercontent.com/10358317/228978295-f822464a-a448-434f-a22e-5f623620d69e.png)

![image](https://user-images.githubusercontent.com/10358317/228978459-8fabb789-eec4-4582-b0e2-4b44d0e2de43.png)
  
- Now, we reach Windows using RDP:
  
![image](https://user-images.githubusercontent.com/10358317/229282800-7ee0cd35-fd46-4ece-9b04-45fa5c785fef.png)
  
- Pinging to Ubuntu20.04 from Windows:
  
![image](https://user-images.githubusercontent.com/10358317/228979379-1ed193a4-c5e4-4526-8a8e-0ecb2cf1a534.png)
  
- Opening firewall rules to ping from Ubuntu to Windows:
- Windows Defender -> Advance Settings -> Inbound Rules -> File and Printer Sharing (Echo Request - ICMPv4 - In) -> Right Click (Enable)
  
![image](https://user-images.githubusercontent.com/10358317/228980207-1f699349-9d09-4304-ad1f-d66187a0b9e1.png)
  
- Pinging to Windows 2019 Server from Ubuntu20.04:
  
![image](https://user-images.githubusercontent.com/10358317/228980821-98c1b545-c1c1-41ca-a53c-f5049641c9df.png)
  
- Viewing Ubuntu CPU, RAM:
  
![image](https://user-images.githubusercontent.com/10358317/228981485-341444fb-f806-49fe-9a6c-c7edc0d25f17.png)
  
![image](https://user-images.githubusercontent.com/10358317/228981584-9823ad8d-169f-4ef2-b4bc-61852b95393b.png)
  
- Destroy infrastructure:

```
terraform destroy 
``` 
  
![image](https://user-images.githubusercontent.com/10358317/229281383-6c8e01ea-af3a-4477-9be6-a10096318333.png)
  
![image](https://user-images.githubusercontent.com/10358317/229281239-b1713771-2960-4746-a1bd-f7543913bd66.png)

- Be sure that instances are terminated. Because if they works, we pay the fee of them:

![image](https://user-images.githubusercontent.com/10358317/228982134-2a648783-0f11-47e9-865d-1dc92dffdd0f.png)

- We can also monitor the CPU, Disk, Network Usage on AWS EC2:
	
![image](https://user-images.githubusercontent.com/10358317/228983384-7b4a0e36-0605-4f33-901f-2a0ebd79c4f6.png)

