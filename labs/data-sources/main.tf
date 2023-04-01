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

# with data source, new resource is not created.  
# data source provides to fetch (read) or retrieve the data from AWS
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
