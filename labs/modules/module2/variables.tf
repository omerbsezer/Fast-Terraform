variable "instance_type" {
    type = string
    description = "EC2 Instance Type"
}

variable "tag" {
    type = string
    description = "The tag for the EC2 instance"
}

variable "location" {
    type = string
    description = "The project region"
    default = "eu-central-1"
}

variable  "availability_zone" {
    type = string
    description = "The project availability zone"
    default = "eu-central-1c"
} 

variable "ami" {
    type = string
    description = "The project region"
}

