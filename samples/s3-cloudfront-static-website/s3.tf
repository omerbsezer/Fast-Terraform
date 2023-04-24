terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-central-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "s3-mybucket-website2023"
  acl    = "private"
  # Add specefic S3 policy in the s3-policy.json on the same directory
  # policy = file("s3-policy.json")

  versioning {
    enabled = false
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
	
	# Add routing rules if required
    # routing_rules = <<EOF
    #                [{
    #                    "Condition": {
    #                        "KeyPrefixEquals": "docs/"
    #                    },
    #                    "Redirect": {
    #                        "ReplaceKeyPrefixWith": "documents/"
    #                    }
    #                }]
    #                EOF
  }

  tags = {
    Environment = "development"
    Name        = "my-tag"
  }

}

#Upload files of your static website
resource "aws_s3_bucket_object" "html" {
  for_each = fileset("${path.module}/website/", "*.html")

  bucket = aws_s3_bucket.mybucket.bucket
  key    = each.value
  source = "${path.module}/website/${each.value}"
  etag   = filemd5("${path.module}/website/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "svg" {
  for_each = fileset("${path.module}/website/", "**/*.svg")

  bucket = aws_s3_bucket.mybucket.bucket
  key    = each.value
  source = "${path.module}/website/${each.value}"
  etag   = filemd5("${path.module}/website/${each.value}")
  content_type = "image/svg+xml"
}

resource "aws_s3_bucket_object" "css" {
  for_each = fileset("${path.module}/website/", "**/*.css")

  bucket = aws_s3_bucket.mybucket.bucket
  key    = each.value
  source = "${path.module}/website/${each.value}"
  etag   = filemd5("${path.module}/website/${each.value}")
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "js" {
  for_each = fileset("${path.module}/website/", "**/*.js")

  bucket = aws_s3_bucket.mybucket.bucket
  key    = each.value
  source = "${path.module}/website/${each.value}"
  etag   = filemd5("${path.module}/website/${each.value}")
  content_type = "application/javascript"
}


resource "aws_s3_bucket_object" "images" {
  for_each = fileset("${path.module}/website/", "**/*.png")

  bucket = aws_s3_bucket.mybucket.bucket
  key    = each.value
  source = "${path.module}/website/${each.value}"
  etag   = filemd5("${path.module}/website/${each.value}")
  content_type = "image/png"
}

resource "aws_s3_bucket_object" "json" {
  for_each = fileset("${path.module}/website/", "**/*.json")

  bucket = aws_s3_bucket.mybucket.bucket
  key    = each.value
  source = "${path.module}/website/${each.value}"
  etag   = filemd5("${path.module}/website/${each.value}")
  content_type = "application/json"
}
# Add more aws_s3_bucket_object for the type of files you want to upload
# The reason for having multiple aws_s3_bucket_object with file type is to make sure
# we add the correct content_type for the file in S3. Otherwise website load may have issues

# Print the files processed so far
output "fileset-results" {
  value = fileset("${path.module}/website/", "**/*")
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.mybucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = true
  block_public_policy     = true
  //ignore_public_acls      = true
  //restrict_public_buckets = true
}