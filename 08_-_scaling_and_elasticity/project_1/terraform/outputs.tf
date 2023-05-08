output "load_blancer_fqdn" {
  value = aws_elb.elb.dns_name
}

output "instance_private_key" {
  sensitive = true
  value     = tls_private_key.keys.private_key_openssh
}
