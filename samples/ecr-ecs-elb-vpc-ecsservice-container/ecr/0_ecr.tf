terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Creating Elastic Container Repository for application
resource "aws_ecr_repository" "flask_app" {
  name = "flask-app"
}


# aws ecr get-login-password --region REGION | docker login --username AWS --password-stdin ID.dkr.ecr.REGION.amazonaws.com 
# docker build -t flask-app .
# docker tag flask-app:latest ID.dkr.REGION.amazonaws.com/flask-app:latest 
# docker push ID.dkr.REGION.amazonaws.com/flask-app:latest