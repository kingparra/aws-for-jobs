resource "tls_private_key" "key_contents" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "key" {
  key_name = "EnergymKeyPair"
  public_key = tls_private_key.key_contents.public_key_openssh
}
