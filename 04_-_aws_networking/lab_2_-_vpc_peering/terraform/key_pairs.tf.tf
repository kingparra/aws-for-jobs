resource "tls_private_key" "key_contents" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "key_object" {
  key_name = "vpc_peering_lab_${random_pet.keypair_suffix.id}}"
  public_key = tls_private_key.key_contents.public_key_openssh
}
