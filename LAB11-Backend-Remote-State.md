## LAB-11: Backend - Remote States => Provision EC2 and Save State File on S3

This scenario shows:
- how to use backend and save Terraform state file on S3

**Code:**  https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/backend-remote-state/

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- With enabling remote state file using backend:
  - multiple user can work on the same state file
  - saving common state file on S3 is possible

- Create S3 bucket on AWS

![image](https://user-images.githubusercontent.com/10358317/230646169-7b9a7210-bd64-4f50-acf7-12690d293490.png)

![image](https://user-images.githubusercontent.com/10358317/230646417-8c460ba7-e45b-4560-8859-d1ebfcac4812.png)


- Create basic main.tf file.


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

  backend "s3" {
    bucket = "terraform-state"
    key = "key/terraform.tfstate"
    region = "eu-central-1"
  }
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

**Code:**  https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/backend-remote-state/main.tf

![image](https://user-images.githubusercontent.com/10358317/230646618-f1200c13-eb83-4bcd-b353-a6c9a02272bd.png)


- Run init, validate command:

``` 
terraform init
terraform validate
``` 

![image](https://user-images.githubusercontent.com/10358317/230646686-0b8ad133-d2e4-4ebf-8505-00eb769b1e5a.png)

- Run plan, apply command:

``` 
terraform plan   # for dry-run
terraform apply
``` 

- On AWS S3, tfstate file is created:

![image](https://user-images.githubusercontent.com/10358317/230647235-3224ec77-2483-460c-81c6-40e9e434f869.png)

- On local machine, state file is not saved now:

![image](https://user-images.githubusercontent.com/10358317/230647627-b5038f51-b34f-443c-b72a-d9c140d3d770.png)

- On AWS, state file can be viewed, downloaded:

![image](https://user-images.githubusercontent.com/10358317/230647970-97d72d67-a588-40ff-a94f-3ea765dfe274.png)

- With pull command, state file can be download on local machine:

``` 
terraform state pull > terraform.tfstate
``` 

![image](https://user-images.githubusercontent.com/10358317/230648330-d89d0b53-617b-4449-a2cb-b92b163cbfdd.png)


- Run destroy command:

``` 
terraform destroy
``` 

- After destroy command,  all resources are deleted in state file on S3:

![image](https://user-images.githubusercontent.com/10358317/230649315-7cb1d236-145b-49ed-ad3f-60aaa01d7ca0.png)

- To download updated state file:

``` 
terraform state pull > terraform.tfstate
``` 
