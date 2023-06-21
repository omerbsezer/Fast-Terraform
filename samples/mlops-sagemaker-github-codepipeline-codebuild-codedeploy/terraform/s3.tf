resource "aws_s3_bucket" "artifacts_bucket" {
  bucket        = var.artifacts_bucket_name
  force_destroy = true
}
