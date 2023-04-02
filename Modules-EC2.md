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

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/labs/modules

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

