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
	region = var.location
}

resource "aws_instance" "instance" {
	ami           = var.ami
	instance_type = var.instance_type

	tags = {
		Name = var.tag
	}
}