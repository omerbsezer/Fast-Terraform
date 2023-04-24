## SAMPLE-08: Provisioning S3 and CloudFront to serve Static Web Site

This sample shows:
- how to create S3 Bucket, 
- how to to copy the website to S3 Bucket, 
- how to configure S3 bucket policy,
- how to create CloudFront distribution to refer S3 Static Web Site,
- how to configure CloudFront (default_cache_behavior, ordered_cache_behavior, ttl, price_class, restrictions, viewer_certificate).

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/s3-cloudfront-static-website/

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- Create s3.tf:
 
```
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
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/s3-cloudfront-static-website/s3.tf

![image](https://user-images.githubusercontent.com/10358317/234043000-4dbbf5bd-8c87-4c3b-872e-6b9958217cc3.png)

- Create cloudfront.tf:
 
```
locals {
  s3_origin_id = "s3-my-website2023"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "s3-my-website2023"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.mybucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "my-cloudfront"
  default_root_object = "index.html"

  # Configure logging here if required 	
  #logging_config {
  #  include_cookies = false
  #  bucket          = "mylogs.s3.amazonaws.com"
  #  prefix          = "myprefix"
  #}

  # If you have domain configured use it here 
  #aliases = ["mywebsite.example.com", "s3-static-web-dev.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN", "IR"]
    }
  }

  tags = {
    Environment = "development"
    Name        = "my-tag"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# to get the Cloud front URL if doamin/alias is not configured
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/s3-cloudfront-static-website/cloudfront.tf

![image](https://user-images.githubusercontent.com/10358317/234043230-49318380-a869-430f-a209-60c5cf367cdd.png)

- Run:
 
```
terraform init
terraform validate
terraform plan
terraform apply
```
- After apply command, provisioning: 

  ![image](https://user-images.githubusercontent.com/10358317/234037248-3be6fbe0-a14f-48e9-b8cb-93d77d932da9.png)

  ![image](https://user-images.githubusercontent.com/10358317/234036899-095e2fe2-aaa4-4a41-a37c-00adc21761a2.png)

- On AWS S3:

  ![image](https://user-images.githubusercontent.com/10358317/234034144-3747b63c-2ca7-4030-9900-7d081fc2c530.png)  

  ![image](https://user-images.githubusercontent.com/10358317/234034725-085b9286-9c78-4770-a9a2-d60d5cb3e4b8.png)

- On AWS CloudFront:

  ![image](https://user-images.githubusercontent.com/10358317/234035736-38d68314-4dfd-4147-a921-9356b313b259.png)

  ![image](https://user-images.githubusercontent.com/10358317/234036235-5d41b526-8bac-41d8-87dc-cf503069e117.png)

  ![image](https://user-images.githubusercontent.com/10358317/234036566-040e8e0f-9972-487f-b533-f60058f6f7f5.png)

- On Browser, website: index.html:

  ![image](https://user-images.githubusercontent.com/10358317/234033141-ee41e25e-e5e6-4962-a21d-ed155eb25197.png)
  
  ![image](https://user-images.githubusercontent.com/10358317/234033367-79f23b83-7e7c-415b-a06f-9c73541e4660.png)

- WebSite: error.html

  ![image](https://user-images.githubusercontent.com/10358317/234033656-8a1d5671-530b-4347-968d-d8b144fda7ff.png)

- Finally, destroy infrastructure:

```
terraform destroy -auto-approve
```

- Destroying takes time:

  ![image](https://user-images.githubusercontent.com/10358317/234040293-3e4f285d-4ef3-483f-bd4d-3ffb41d94b73.png)

  ![image](https://user-images.githubusercontent.com/10358317/234040667-e9b5c723-15fa-4d05-a628-eb15e4714e10.png)

## Reference
- Website Source Code: https://github.com/StartBootstrap/startbootstrap-freelancer
- https://towardsaws.com/provision-a-static-website-on-aws-s3-and-cloudfront-using-terraform-d8004a8f629a
