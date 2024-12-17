## SAMPLE-03: EBS (Elastic Block Store: HDD, SDD) and EFS (Elastic File System: NFS) Configuration with EC2s (Ubuntu and Windows Instances)

This sample shows:
- how to provision EBS, mount on Ubuntu and Windows Instances.
- how to provision EFS, mount on Ubuntu Instance.
  - EFS is not supported on Windows Instance: https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/AmazonEFS.html
- how to provision VPC, subnet, IGW, route table, security group. 

![aws-ebs-efs](https://github.com/user-attachments/assets/dc4efaf8-9d16-4a83-aeeb-9c0a082a4903)

There are 3 main parts:
- **main.tf**: It includes 2 EC2 (Ubuntu, Windows), VPC, subnet, IGW, route table, security group implementation.
- **efs.tf**: It includes EFS configuration for Ubuntu EC2. 
- **ebs.tf**: It includes EBS configuration for both Ubuntu and Windows EC2s.

![image](https://user-images.githubusercontent.com/10358317/230903321-5bca3385-9564-44f1-bde8-fe1c873c870a.png)

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/ec2-ebs-efs

# Table of Contents
- [Key-Pair](#keypair)
- [VPC, EC2, SG Implementation](#vpc)
- [EBS Implementation](#ebs)
- [EFS Implementation](#efs)
- [Terraform Run](#run)
- [EBS Final Setup and Test on Ubuntu](#ebsfinalubuntu)
- [EFS Final Setup and Test on Ubuntu](#efsfinalubuntu)
- [EBS Final Setup and Test on Windows](#ebsfinalwindows)



### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

### Key-Pair <a name="keypair"></a>

 SSH key-pairs (public and private key) are used to connect remote server. Public key (xx.pub) is on the remote server, with private key, user can connect using SSH.

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

### VPC, EC2, SG Implementation <a name="vpc"></a>

- Create main.tf:
 
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
  }
  required_version = ">= 1.10.2"
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

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ec2-ebs-efs/main.tf

![image](https://user-images.githubusercontent.com/10358317/228973324-4bc1c6ad-1099-4f56-8e6f-c002f719d9d4.png)

### EBS Implementation <a name="ebs"></a>

- Create ebs.tf:
 
```
# Creating EBS for Ubuntu
# details: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
resource "aws_ebs_volume" "ebs_ubuntu" {
  availability_zone = "eu-central-1c"
  size = 20   # The size of the drive in GiBs.
  type= "gp2" # default gp2. others: standard, gp2, gp3, io1, io2, sc1 or st1
}

# EBS-Ubuntu attachment
resource "aws_volume_attachment" "ubuntu2004_ebs_ubuntu" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.ebs_ubuntu.id}"
  instance_id = "${aws_instance.ubuntu2004.id}"
}

# Creating EBS for Windows
# details: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume
resource "aws_ebs_volume" "ebs_windows" {
  availability_zone = "eu-central-1c"
  size = 15   # The size of the drive in GiBs.
  type= "gp2" # default gp2. others: standard, gp2, gp3, io1, io2, sc1 or st1
}

# EBS-Windows attachment
resource "aws_volume_attachment" "win2019_ebs_windows" {
  device_name = "/dev/sdg"
  volume_id   = "${aws_ebs_volume.ebs_windows.id}"
  instance_id = "${aws_instance.win2019.id}"
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ec2-ebs-efs/ebs.tf

![image](https://user-images.githubusercontent.com/10358317/230891729-cda1f5a7-0d7e-4763-ad26-709b23596ad5.png)

### EFS Implementation <a name="efs"></a>

- Create efs.tf:
 
```
# Creating Amazon EFS File system
# Amazon EFS supports two lifecycle policies. Transition into IA and Transition out of IA
resource "aws_efs_file_system" "efs" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "efs-example"
  }
}

# Creating the EFS access point for AWS EFS File system
resource "aws_efs_access_point" "access_point" {
  file_system_id = aws_efs_file_system.efs.id
}

# Creating the AWS EFS System policy to transition files into and out of the file system.
# The EFS System Policy allows clients to mount, read and perform, write operations on File system 
# The communication of client and EFS is set using aws:secureTransport Option
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy01",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.efs.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}

# Creating the AWS EFS Mount point in a specified Subnet 
resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.public.id
  security_groups = [aws_security_group.sg_config.id]  # open ingress 2049 port for EFS
}

resource "null_resource" "configure_nfs" {
  depends_on = [aws_efs_mount_target.mount]
   
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("testkey.pem")
    host     = aws_instance.ubuntu2004.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt install nfs-common -y",
      "mkdir ~/efs",
      "cd ~/efs",
      "df -kh"
    ]
  }
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ec2-ebs-efs/efs.tf

![image](https://user-images.githubusercontent.com/10358317/230891861-918ccb30-f78e-45be-9780-5d9046a829de.png)

### Terraform Run <a name="run"></a>

- Run init, validate, plan, apply commands:

``` 
terraform init
terraform validate
terraform plan
terraform apply
``` 

![image](https://user-images.githubusercontent.com/10358317/230892963-1699dbe3-5b7e-43a2-a2a0-bfd71e463c41.png)

![image](https://user-images.githubusercontent.com/10358317/230893093-c7e6f1dd-f5f0-4b57-9c67-b56d6a872fbb.png)

### EBS Final Setup and Test on Ubuntu <a name="ebsfinalubuntu"></a>

- On AWS EC2:

![image](https://user-images.githubusercontent.com/10358317/230893309-620f3483-4056-4685-ada9-e49f88e8cc64.png)

- On AWS EC2 Volumes, EC2 have default root volumes (8GB, 30GB).
- New addition volumes (15GB, 20GB) are added as a second volume of EC2s.

![image](https://user-images.githubusercontent.com/10358317/230893508-3ca0ae47-0738-46af-b8b6-2e59ce022034.png)

- Connect to the Ubuntu via SSH:

```
ssh -i .\testkey.pem ubuntu@3.69.53.254
lsblk
```

![image](https://user-images.githubusercontent.com/10358317/230894465-f33c048f-78aa-47f0-8c5b-878cd8a4368c.png)

- Formatting disk, mounting EBS:

```
sudo file -s /dev/xvdh       # “/dev/xvdf: data“, it means your volume is empty.

#format, Format the volume to the ext4 or xfs
sudo mkfs -t ext4 /dev/xvdh  # prefer ext4  
# sudo mkfs -t xfs /dev/xvdh

# mounting EBS
sudo mkdir newvolume
sudo mount /dev/xvdh newvolume
cd newvolume
df -h .
```

![image](https://user-images.githubusercontent.com/10358317/230894735-e13ebfb7-fb47-4d98-ae11-7e2358294c92.png)

### EFS Final Setup and Test on Ubuntu <a name="efsfinalubuntu"></a>

- Go to EFS Service, new EFS filesystem:

![image](https://user-images.githubusercontent.com/10358317/230894988-0a461c41-e8e2-4dfb-a44e-34b5a88f973d.png)

- Click "Attach" to attach EFS to EC2:

![image](https://user-images.githubusercontent.com/10358317/230895234-e9497503-0345-4cb3-9332-9b62202d7e37.png)

- Copy the command:

![image](https://user-images.githubusercontent.com/10358317/230895361-1d45f9fa-cc76-4261-9cc0-460e7d704182.png)

- Mount the EFS:

```
e.g. sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0adf50bc47d99ff95.efs.eu-central-1.amazonaws.com:/ efs
```

- After mounting EFS, EFS mounted directory can be seen in the list.
- Although creating 2 x 200MB files, root part's size does not change. It shows that EFS is mounted successfully, files are created on EFS part.

![image](https://user-images.githubusercontent.com/10358317/230896271-ded8a2f6-cfb8-4d18-a29d-fba4277126cc.png)

### EBS Final Setup and Test on Windows <a name="ebsfinalwindows"></a>

- Connect Windows with RDP, get password using pem key:

![image](https://user-images.githubusercontent.com/10358317/230897189-9d7fcb1a-0129-4b6a-a06e-64715e645476.png)

![image](https://user-images.githubusercontent.com/10358317/230897253-09e44ee7-ca2c-4720-ab25-f912213a15f1.png)


- For mounting disk on Windows:
  - Folow: https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ebs-using-volumes.html, open disk management utility

- Make "Online" the disk:

![image](https://user-images.githubusercontent.com/10358317/230897820-eefb2070-d7a4-4d0b-b466-06441ef7e44b.png)

- Make "Initialize" the disk, with MBR:

![image](https://user-images.githubusercontent.com/10358317/230898135-6f8d7012-10b3-4e4b-bf29-27619166782d.png)

- New Simple Volume:

![image](https://user-images.githubusercontent.com/10358317/230898370-40f2b976-3a7c-4b7b-ae3e-0897b0c3a277.png)

- Final configuration:

![image](https://user-images.githubusercontent.com/10358317/230898488-a35862a9-d171-40b5-8f1d-4f97a986346a.png)

- New EBS disk is mounted successfully:

![image](https://user-images.githubusercontent.com/10358317/230898597-ca1d7ffe-80ba-45cb-9465-1463436392ae.png)

- Destroy infrastructure:

```
terraform destroy 
``` 

- It is easy to manage 17 resources:

![image](https://user-images.githubusercontent.com/10358317/230901325-0a1cd3c1-2080-4749-a084-f370c17b95de.png)

## References:
- https://adamtheautomator.com/terraform-efs/
- https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ebs-using-volumes.html
