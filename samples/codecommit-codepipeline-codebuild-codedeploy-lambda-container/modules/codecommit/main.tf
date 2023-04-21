
data "aws_caller_identity" "current" {}
resource "aws_codecommit_repository" "codecommit_repo" {
  repository_name = "${var.general_namespace}_code_repo"
  default_branch  = "${var.codecommit_branch}"
  description     = "Application repo for lambda ${var.general_namespace}"
}