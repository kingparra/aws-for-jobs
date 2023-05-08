resource "tls_private_key" "key_contents" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "key_object" {
  key_name = "lab1key_${random_pet.session_name.id}"
  public_key = tls_private_key.key_contents.public_key_openssh
}
