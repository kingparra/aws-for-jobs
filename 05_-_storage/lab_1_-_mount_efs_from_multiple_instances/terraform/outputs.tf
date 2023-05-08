output "private_key" {
  value = tls_private_key.key_contents.private_key_openssh
  sensitive = true
}

output "fs_id" {
  value = aws_efs_file_system.fs.id
}

output "client_1_ip" {
  value = aws_instance.nfs_client_1.public_ip
}

output "client_2_ip" {
  value = aws_instance.nfs_client_2.public_ip
}
