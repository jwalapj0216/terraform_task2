
resource "tls_private_key" "key1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "key2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp1" {
  provider   = aws.region1
  key_name   = "region1-key"
  public_key = tls_private_key.key1.public_key_openssh
}

resource "aws_key_pair" "kp2" {
  provider   = aws.region2
  key_name   = "region2-key"
  public_key = tls_private_key.key2.public_key_openssh
}
