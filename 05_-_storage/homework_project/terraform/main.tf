terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.54.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "aws" {
  shared_config_files = ["/home/chris/.aws/config"]
  shared_credentials_files = ["/home/chris/.aws/credentials"]
  profile = "default"
  region = "us-east-1"
  default_tags {
    tags = {
      AfjModule = "5"
      AssignmentName = "host_a_static_website_with_s3"
    }
  }
}

provider "random" {}

resource "random_pet" "bucket_name" {
  length = 3
}

# This is way too granular, I hate it!

resource "aws_s3_bucket" "bucket" {
  bucket = random_pet.bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_policy" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      },
    ]
  })
}

module "template_files" {
  # This is needed to provide the content_type attribute
  # if a correct content_type is not set, files will be
  # downloaded by the browser instead of viewd.
  source = "hashicorp/dir/template"
  base_dir = "${path.module}/static-website-code"
}

resource "aws_s3_object" "static_site_content" {
  for_each = module.template_files.files
  bucket = aws_s3_bucket.bucket.id
  source = each.value.source_path
  key = each.key
  source_hash = each.value.digests.md5
  content_type = each.value.content_type
}


resource "aws_s3_bucket_website_configuration" "conf" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error/error.html"
  }
}

# TODO: Associate with a domain name
/*
resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = data.aws_s3_bucket.selected-bucket.bucket
cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }
}
resource "aws_route53_zone" "main" {
  name = var.domain_name
  tags = {
    Name = "www.${var.domain_name}"
    description = var.domain_name
  }
  comment = var.domain_name
}
resource "aws_route53_record" "www-a" {
  zone_id = aws_route53_zone.main.zone_id
  name = "www.${var.domain_name}"
  type = "A"
alias {
    name = data.aws_s3_bucket.selected-bucket.website_domain
    zone_id = data.aws_s3_bucket.selected-bucket.hosted_zone_id
    evaluate_target_health = false
  }
}
*/

# TODO: Set up TLS

# TODO: Set up a CDN

output "website_endpoint_url" {
  value = "http://${aws_s3_bucket_website_configuration.conf.website_endpoint}"
}
