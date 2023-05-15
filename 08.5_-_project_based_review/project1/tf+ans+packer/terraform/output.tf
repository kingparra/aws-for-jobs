output "private_key" {
  value = tls_private_key.key_contents.private_key_openssh
  sensitive = true
}

output "s3ful_arn" {
  value = data.aws_iam_policy.S3full
}

output "alb_endpoint_url" {
  value = aws_lb.site_alb.dns_name
}
