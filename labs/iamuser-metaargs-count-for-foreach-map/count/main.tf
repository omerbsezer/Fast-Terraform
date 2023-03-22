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
   region     =  "eu-central-1"
}

resource "aws_instance" "ec2_example" {

   ami           = "ami-0d1ddd83282187d18" # Ubuntu 22.04 eu-central-1 Frankfurt
   instance_type = "t2.nano"
   count = 1

   tags = {
           Name = "Terraform EC2"
   }

}
#####################################################
# With Count
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}
# count, use list 
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3"]
}
#####################################################
# With for loop
output "print_the_names" {
  value = [for name in var.user_names : name]
}
