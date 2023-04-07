variable "instance_type" {
    type = string
    description = "EC2 Instance Type"
}

variable "location" {
    type = string
    description = "The project region"
    default = "eu-central-1"
}

variable "ami" {
    type = string
    description = "The project region"
}
