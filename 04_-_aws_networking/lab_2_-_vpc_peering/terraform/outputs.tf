output "private_key" {
  value = tls_private_key.key_contents.private_key_openssh
  sensitive = true
}

output "vpc_a_intance_ip" {
  value = aws_instance.vpc_a_instance.public_ip
}

output "vpc_b_instance_ip" {
  value = aws_instance.vpc_b_instance.public_ip
}
