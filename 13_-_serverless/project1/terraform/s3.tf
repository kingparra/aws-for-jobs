# Create the bucket
resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "static-site-bucket-curly-dolphin-soup"
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.static_site_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Give it public access
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.static_site_bucket.id
}

# Set up static site hosting. Outputs: website_endpoint. Used in index.html.
resource "aws_s3_bucket_website_configuration" "webconf" {
  bucket = aws_s3_bucket.static_site_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# Attach a bucket policy
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.static_site_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_any_account.json
}

# Create the policy document to be attached
data "aws_iam_policy_document" "allow_access_from_any_account" {
  statement {
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.static_site_bucket.arn,
      "${aws_s3_bucket.static_site_bucket.arn}/*",
    ]
  }
}

# Enumerate files under assets/site and gather file data.
module "template_files" {
  source = "hashicorp/dir/template"
  base_dir = "${path.module}/assets/site/"
}

# Upload the files as objcets to the bucket, using file metadata.
# Content (MIME) type is required in order for browsers to render files correctly.
resource "aws_s3_object" "static_site_content" {
  for_each = module.template_files.files
  bucket = aws_s3_bucket.static_site_bucket.id
  source = each.value.source_path
  key = each.key
  source_hash = each.value.digests.md5
  content_type = each.value.content_type
}
