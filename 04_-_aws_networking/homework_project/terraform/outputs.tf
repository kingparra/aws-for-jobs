output "session_name" {
  value = random_pet.session_name.id
}

output "private_key" {
  value = tls_private_key.key_contents.private_key_openssh
  sensitive = true
}

output "public_instance_ip" {
  value = aws_instance.public_instance.public_ip
}

output "private_instance_ip" {
  value = data.aws_instance.private_instance_facts.private_ip
}
