variable "repository_branch" {
  description = "Repository branch to connect to"
  default     = "<your branch>"
}
variable "env" {
  description = "Deployment environment"
  default     = "dev"
}
variable "project_name" {
  description = "Project name"
  default     = "<project_name>"
}
variable "project_id" {
  description = "Project ID"
  default     = "<project_id>"
}
variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "repository_owner" {
  description = "GitHub repository owner"
  default     = "<your id>"
}

variable "build_repository_name" {
  description = "GitHub repository name"
  default     = "modelbuild_pipeline"
}

variable "deploy_repository_name" {
  description = "GitHub repository name"
  default     = "modeldeploy_pipeline"
}

variable "artifacts_bucket_name" {
  description = "S3 Bucket for storing artifacts"
  default     = "<your bucket name>"
}

variable "github_token" {
  description = "GitHub token"
  default     = "<your token>"
}
