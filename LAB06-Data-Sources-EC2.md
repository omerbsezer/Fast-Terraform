## LAB-06: Data Sources with Depends_on => Provision EC2

This scenario shows:
- how to use Data Source to fetch/retrieve data (existed resource information) from AWS

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/data-sources/main.tf

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- With data sources, existed resource information can be fetched/retrieved.
- "filter" provide to select/filter the existed instances
- "depends_on" provide to run the data block after resource created 
 
``` 
...
data "aws_instance" "data_instance" {
    filter {
      name = "tag:Name"
      values = ["Basic Instance"]
    }

    depends_on = [
      aws_instance.instance
    ]
} 

output "instance_info" {
  value = data.aws_instance.data_instance
}
...
``` 

![image](https://user-images.githubusercontent.com/10358317/229291040-febb8404-4c00-48c3-b99d-ea0af0e68825.png)

- Create main.tf:

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

resource "aws_instance" "instance" {
	ami           = "ami-0d1ddd83282187d18" # Ubuntu 22.04 eu-central-1 Frankfurt
	instance_type = "t2.nano"

	tags = {
		Name = "Basic Instance"
	}
}

# filter/select the existed instances
# depends_on if aws_instance.instance is created

data "aws_instance" "data_instance" {
    filter {
      name = "tag:Name"
      values = ["Basic Instance"]
    }

    depends_on = [
      aws_instance.instance
    ]
} 

output "instance_info" {
  value = data.aws_instance.data_instance
}

output "instance_public_ip" {
  value = data.aws_instance.data_instance.public_ip
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/data-sources/main.tf

![image](https://user-images.githubusercontent.com/10358317/229291093-e5febd7a-fa05-44bc-a224-00a18035b869.png)

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

![image](https://user-images.githubusercontent.com/10358317/229291488-831a796e-b77a-43ee-92a1-814630834907.png)

![image](https://user-images.githubusercontent.com/10358317/229291530-985497f5-87a4-41d8-8fec-3f6217d62e6d.png)

- With output, details can be viewed:

![image](https://user-images.githubusercontent.com/10358317/229291636-963cfbf8-4735-4d62-bae4-c803f70a1775.png)

![image](https://user-images.githubusercontent.com/10358317/229291821-28dea44f-04cf-42ef-b436-cbdfc77bd294.png)

- Destroy infrastructure:

```
terraform destroy 
``` 

![image](https://user-images.githubusercontent.com/10358317/229291943-7a61e1c5-743f-4508-928f-04d738c2bb5a.png)

![image](https://user-images.githubusercontent.com/10358317/229291973-1d789992-8a90-4709-8da1-2db5b3b79b46.png)


