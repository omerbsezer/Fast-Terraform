#Values are retrived from terraform.tfvars file
variable "org_name" {
  description = "Your Organization name"
  type        = string
}
variable "team_name" {
  description = "Your Team name"
  type        = string
}
variable "project_id" {
  description = "Your Project ID"
  type        = string
}
variable "env" {
  description = "Your deployment environment"
  type        = map(any)
  default = {
    "dev" = "dev"
  }
}
variable "region" {
  description = "Your AWS Region"
  type        = string
}
variable "codebuild_type" {
  description = "Your CodeBuild Project Type"
  type        = string
}
variable "codebuild_image" {
  description = "Your CodeBuild Project Image"
  type        = string
}
variable "codebuild_compute_type" {
  description = "Your CodeBuild Project Compute Type"
  type        = string
}
variable "codecommit_branch" {
  description = "Your CodeCommit Branch"
  type        = string
}
variable "terraform_ver" {
    description = "Terraform Version number for passing it to codebuild"
    default     = "1.2.2"
    type        = string
}