# Generate key pair
resource "tls_private_key" "utc_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

#public key in aws 
resource "aws_key_pair" "utc_key" {
  key_name   = "utc-key"
  public_key = tls_private_key.utc_key.public_key_openssh
}

#Download key
resource "local_file" "localf1" {
  filename        = "utc-key.pem"
  content         = tls_private_key.utc_key.private_key_pem
  file_permission = 0400
}