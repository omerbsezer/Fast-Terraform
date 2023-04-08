## LAB-08: Modules => Provision EC2

This scenario shows:
- how to create and use modules 

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/labs/modules

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- With modules, it helps:
  - organize configuration
  - encapsulation 
  - re-usability
  - consistency

- Main.tf refers modules (directories)
- Each modules have variables.tf


### Module Calls (Main.tf)

**Main.tf Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/modules/main.tf

``` 
...
module "webserver-1" {
  source = ".//module1"

  instance_type     =   "t2.nano"
  tag               =   "Webserver1 - Module1 - 20.04"
  location          =   "eu-central-1"
  availability_zone =   "eu-central-1c"
  ami               =   "ami-0e067cc8a2b58de59" # Ubuntu 20.04 eu-central-1 Frankfurt

}

module "webserver-2" {
  source = ".//module2"

  instance_type     =   "t2.micro"
  tag               =   "Webserver2 - Module2 - 22.04"
  location          =   "eu-central-1"
  availability_zone =   "eu-central-1a"
  ami               =   "ami-0d1ddd83282187d18" # Ubuntu 22.04 eu-central-1 Frankfurt
}
``` 

![image](https://user-images.githubusercontent.com/10358317/229362702-43148537-03fc-4876-9883-ccee83a63f56.png)

### Module1

**Module1 Variables.tf Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/modules/module1/variables.tf

``` 
variable "instance_type" {
    type = string
    description = "EC2 Instance Type"
}

variable "tag" {
    type = string
    description = "The tag for the EC2 instance"
}

variable "location" {
    type = string
    description = "The project region"
    default = "eu-central-1"
}

variable  "availability_zone" {
    type = string
    description = "The project availability zone"
    default = "eu-central-1c"
} 

variable "ami" {
    type = string
    description = "The project region"
}
``` 

**Module1 Main.tf Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/modules/module1/main.tf


### Module2

- Module2 variables.tf is same as module1 variables.tf

**Module2 Variables.tf Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/modules/module2/variables.tf

- Module2 main.tf code is different from module1 main.tf

**Module2 Main.tf Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/modules/module2/main.tf

### Terraform Run

- Run init, validate command:

``` 
terraform init
terraform validate
``` 

![image](https://user-images.githubusercontent.com/10358317/229363829-54d98270-7cb6-499d-8ca5-235187945e78.png)

![image](https://user-images.githubusercontent.com/10358317/229363852-4df92036-b8d1-4206-9da9-d6769237f46f.png)

- Run plan, apply command:

``` 
terraform plan
terraform apply
``` 

![image](https://user-images.githubusercontent.com/10358317/229364064-2ac5ad88-f93c-4cb3-a803-de43a10e5885.png)

![image](https://user-images.githubusercontent.com/10358317/229364027-755c7df6-4ecb-4fe0-9c10-ee30ecfa31c0.png)

- On AWS, 2 EC2 Instances:

![image](https://user-images.githubusercontent.com/10358317/229364124-4ce9c58c-c2e2-42e6-8f00-13a8c63185a0.png)

![image](https://user-images.githubusercontent.com/10358317/229364304-23917adf-d488-4294-bc49-ce89c879817a.png)


- On AWS, 2 VPCs:

![image](https://user-images.githubusercontent.com/10358317/229364188-792953e2-0d57-4560-8591-3c13203864ab.png)

![image](https://user-images.githubusercontent.com/10358317/229364233-41b910a9-d6cc-4e09-bbb7-11dd2054de56.png)

- On Browser:

![image](https://user-images.githubusercontent.com/10358317/229364349-7572c383-e934-4e6b-b0be-f3ba4c098ac4.png)

![image](https://user-images.githubusercontent.com/10358317/229364366-ba334719-7789-42f7-b5e4-7cecfc7eb42a.png)

- Destroy infrastructure:

```
terraform destroy 
``` 

![image](https://user-images.githubusercontent.com/10358317/229364565-c6f07625-008b-4e64-a62b-dc80ea6db4e3.png)

![image](https://user-images.githubusercontent.com/10358317/229364693-bcc9c21d-d091-49ef-b176-d71cabf813fb.png)

- On AWS, EC2s are terminated:

![image](https://user-images.githubusercontent.com/10358317/229364904-22116720-7b4a-42d3-8b10-a34fc9dccafb.png)

