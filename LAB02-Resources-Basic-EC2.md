## LAB-02: Resources => Provision Basic EC2 (Ubuntu 22.04)

This scenario shows:
- how to create EC2 with Ubuntu 22.04

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/basic-resource-ec2-ubuntu/main.tf

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- Create main.tf and copy the code
 
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

resource "aws_instance" "instance" {
	ami           = "ami-0d1ddd83282187d18" # Ubuntu 22.04 eu-central-1 Frankfurt
	instance_type = "t2.nano"

	tags = {
		Name = "Basic Instance"
	}
}
``` 

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/basic-resource-ec2-ubuntu/main.tf

![image](https://user-images.githubusercontent.com/10358317/227008999-64295471-d0b3-48c8-a717-e6323c2091e9.png)


- Run init command:

``` 
terraform init
``` 

![image](https://user-images.githubusercontent.com/10358317/227001872-ef246cee-f8a9-4c66-845b-17d7ad32e8a5.png)
  
- Init command downloads required executable files from Terraform (.terraform):

![image](https://user-images.githubusercontent.com/10358317/227002641-a15545c6-9e40-4f23-80a6-ed07b2c4b7b1.png)
 
- Validate file:

``` 
terraform validate
``` 

![image](https://user-images.githubusercontent.com/10358317/227002220-a6d67605-e870-40e1-9e0f-252f68c4ba0a.png)


- Run plan command:

``` 
terraform plan
``` 

![image](https://user-images.githubusercontent.com/10358317/227003057-6805d76e-75a1-440d-a288-876668fe7e27.png)
  
![image](https://user-images.githubusercontent.com/10358317/227003299-c02f0d18-7588-4b41-8a80-5e180ffea50e.png)
  
- Run apply command to create resources. Then, Terraform asks to confirm, write "yes":

``` 
terraform apply
```   

![image](https://user-images.githubusercontent.com/10358317/227007465-7f4a1315-6f16-45af-a21b-25d896a718a7.png)

- It creates the resources that are defined in the main.tf:

![image](https://user-images.githubusercontent.com/10358317/227007779-6fea1041-31c3-4f0f-b8c2-a1673bfef150.png)

- After apply command, terraform creates state files:

![image](https://user-images.githubusercontent.com/10358317/227009288-9009ff78-0b24-451a-a5a5-5533b9d3c0fb.png)

- On AWS, go to EC2 services:

![image](https://user-images.githubusercontent.com/10358317/227004589-8329e520-ce4a-4cf7-8eb9-a4e71f4d46a1.png)

- On EC2 Dashboard: 

![image](https://user-images.githubusercontent.com/10358317/227004417-47f719c4-8ccc-413d-a17d-11409e82173d.png)

- Security Group Configuration is configured as default, inbound ports are defined as "all" (this is not good for security, but for now, it's ok!), egress ports are defined as "all"

![image](https://user-images.githubusercontent.com/10358317/227005971-42e763de-734c-47d7-9916-a490ee97f8ee.png)

- Network Configuration is configured as default, but availability zone is defined as "eu-central-1"

![image](https://user-images.githubusercontent.com/10358317/227005316-351ea88a-dbd5-4820-a2f8-0d768437c3c7.png)
 
- Storage Configuration is configured as default, 8GB EBS (Elastic Block Storage) is attached:

![image](https://user-images.githubusercontent.com/10358317/227005692-9721e61a-9217-45ca-a466-d4717fb91ff1.png)

- Delete all resources. Then, Terraform asks to confirm, write "yes"::

``` 
terraform destroy
``` 

![image](https://user-images.githubusercontent.com/10358317/229283240-60381539-93e7-4795-bdb0-7ab179cf7ed4.png)

![image](https://user-images.githubusercontent.com/10358317/229283607-5eb607f0-ad8a-46fb-9f1b-e6aee38fb4db.png)
  
- On AWS EC2 Instances, EC2 was terminated, it'll be disappeared in max. 1 hour. Once an EC2 is terminated, that EC2 is deleted permanently:

![image](https://user-images.githubusercontent.com/10358317/227008611-4c7e0d5f-2765-47f5-9b6f-af78d4d7314f.png)
 
- Destroy command is important to terminate the resources. 
- If you forget the destroy command, your EC2 runs until termination and you MUST pay the usage price of EC2.

![image](https://user-images.githubusercontent.com/10358317/227049834-12b0223c-fd10-46ca-9602-391e6267434f.png)

- It is really IMPORTANT to check whether unnecessary paid services are closed or not.

![image](https://user-images.githubusercontent.com/10358317/227050101-0dd27ac2-b10f-4812-90f9-18cfbc51de80.png)


