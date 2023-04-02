## LAB: Modules EC2

This scenario shows:
- how to create and use modules 

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/labs/modules

### Prerequisite

- You should have a look following lab: 
  - [LAB: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/Terraform-Install-AWS-Configuration.md)

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

- Run plan, apply command:

``` 
terraform plan
terraform apply
``` 




- Destroy infrastructure:

```
terraform destroy 
``` 

