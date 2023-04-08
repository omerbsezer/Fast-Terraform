## LAB-07: Provisioners (file, remote-exec), Null Resources (local-exec) => Provision Key-Pair, SSH Connection

This scenario shows:
- how to create file, run command using "remote-exec" provisioners on remote instance,
- how to create file using provisioner "file" on remote instance,
- how to create file, run command using "local-exec" on local pc,
- how to create key-pairs for SSH connection.

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/provisioners-nullresources/main.tf

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

- With provisioner "file", on the remote instance, new file can be created
- With provisioner "remote-exec", on the remote instance, any command can be run
- With provisioner "local-exec", on the local PC, any command can be run on any shell (bash, powershell)
- With "null_resource", without creating any resource, any command can be run.
- Provisioners in the resource only runs once while creating resource on remote instance 
- Provisioners in the "null_resource" run multiple times and it doesn't depend on the resource.  
 
``` 
...
resource "aws_instance" "ubuntu2204" {

  ...
  provisioner "file" {
    source      = "test-file.txt" 
    destination = "/home/ubuntu/test-file.txt"
  }

  provisioner "file" {
    content     = "I want to copy this string to the destination file => server.txt (using provisioner file content)"
    destination = "/home/ubuntu/server.txt"
  }
  
  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote-exec provisioner >> hello.txt",
    ]
  }

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("testkey.pem")
      timeout     = "4m"
   }
}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "'This is test file for null resource local-exec' >>  nullresource-generated.txt"
    interpreter = ["PowerShell", "-Command"]
  }
}
...
``` 

![image](https://user-images.githubusercontent.com/10358317/229303293-52a67375-9d3f-43f0-86a3-955ff6e6613a.png)

- Create main.tf

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

resource "aws_instance" "ubuntu2204" {

  ami                         = "ami-0d1ddd83282187d18" # Ubuntu 22.04 eu-central-1 Frankfurt
  instance_type               = "t2.nano" 
  key_name                    = "testkey"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  tags = {
    Name = "Ubuntu 22.04"
  }

  provisioner "file" {
    source      = "test-file.txt" 
    destination = "/home/ubuntu/test-file.txt"
  }

  provisioner "file" {
    content     = "I want to copy this string to the destination file => server.txt (using provisioner file content)"
    destination = "/home/ubuntu/server.txt"
  }
  
  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote-exec provisioner >> hello.txt",
    ]
  }

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("testkey.pem")
      timeout     = "4m"
   }
}

resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "'This is test file for null resource local-exec' >>  nullresource-generated.txt"
    interpreter = ["PowerShell", "-Command"]
  }
}
``` 

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/provisioners-nullresources/main.tf

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

![image](https://user-images.githubusercontent.com/10358317/229302416-31b1baa5-7aac-45fa-8ca5-15120b0c6f2e.png)

![image](https://user-images.githubusercontent.com/10358317/229302498-c338ee6c-b16d-4e4a-a21b-3577c9403aed.png)

- On AWS EC2 Instance:

![image](https://user-images.githubusercontent.com/10358317/229302953-73056a26-c85e-4fad-ba68-115f3fc3dcf1.png)

- Make SSH connection:

``` 
ssh -i testkey.pem ubuntu@<PublicIP>
``` 

- Provisioners run and files were created on remote instance:

![image](https://user-images.githubusercontent.com/10358317/229302702-57df3eec-f6f9-4d5e-af1b-bfb47cc9a906.png)

- On local PC, local provisioner also created file:

![image](https://user-images.githubusercontent.com/10358317/229302840-0e17e5ac-cc34-4252-9cf6-9df56a034a4a.png)

- Destroy infrastructure:

```
terraform destroy 
``` 

![image](https://user-images.githubusercontent.com/10358317/229303068-c096e9f4-c6b6-45e4-b3a9-71ef0336a755.png)

![image](https://user-images.githubusercontent.com/10358317/229303188-3fd076c2-fac4-4ef2-8c7d-958c0f825640.png)

- On AWS EC2 Instance:

![image](https://user-images.githubusercontent.com/10358317/229303226-adaead1f-6f6a-4138-9640-4dfce873166c.png)

