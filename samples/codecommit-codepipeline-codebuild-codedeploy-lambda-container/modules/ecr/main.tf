
data "aws_caller_identity" "current" {}
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.general_namespace}_docker_repo"
  #image_tag_mutability = "IMMUTABLE" #a capability that prevents image tags from being overwritten
  image_scanning_configuration {
    scan_on_push = true #https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html
  }
  tags = {
    env = var.env_namespace
  }
}