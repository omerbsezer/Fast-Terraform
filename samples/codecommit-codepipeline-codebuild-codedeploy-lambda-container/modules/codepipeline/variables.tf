variable "codecommit_branch" {
    type = string
}
variable "codecommit_repo" {
    type = string
}
variable "general_namespace" {
    type = string
}
variable "env_namespace" {
    type = string
}
variable "s3_bucket_namespace" {
    type = string
}
variable "ecr_repo_arn" {
    type = string
}
variable "codebuild_image" {
    type = string
    default = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}
variable "codebuild_type" {
    type = string
    default = "LINUX_CONTAINER"
}
variable "codebuild_compute_type" {
    type = string
    default = "BUILD_GENERAL1_MEDIUM"
}
variable "build_args" {
    type        = any
}