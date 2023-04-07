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
