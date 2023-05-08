resource "random_pet" "bucket_name" {
  length = 3
  keepers = aws_s3_bucket.bucket
}

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
# Download the zip archive
# "https://learn.yellowtail.tech/cbf5c921-5c80-4f45-9b01-3c58c6f426b4"
# Unzip it to static-webiste-code
# Clean up the files after uploading them as objects to our S3 bucket

module "template_files" {
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
