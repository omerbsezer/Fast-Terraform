terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


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