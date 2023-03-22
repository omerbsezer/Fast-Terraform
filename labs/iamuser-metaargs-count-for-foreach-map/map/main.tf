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
# With for_each
resource "aws_iam_user" "example" {
  for_each = var.user_names
  name  = each.value
}
# With Map
variable "iam_users" {
  description = "map"
  type        = map(string)
  default     = {
    user1      = "normal user"
    user2      = "admin user"
    user3      = "root user"
  }
}
# with for loop on map 
output "user_with_roles" {
  value = [for name, role in var.iam_users : "${name} is the ${role}"]
}
