provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
      # Will allow installation of 4.15.1 and 4.15.10 but not 4.16.0
      # Get error when using 4.16.0
    }
  }
}

# terraform {
#     backend "s3" {
#       encrypt = true
#       bucket = "BUCKET_NAME"
#       key = "states/code/terraform.tfstate"
#       region = "eu-central-1"
#   }
# }
