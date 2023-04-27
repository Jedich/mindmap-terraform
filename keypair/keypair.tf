resource "tls_private_key" "key_data" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.project_name}-${terraform.workspace}"
  public_key = tls_private_key.key_data.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.key_data.private_key_pem
  filename = "output/key/${aws_key_pair.generated_key.key_name}.pem"
}

output "generated_key" {
  value = {
    public_key = aws_key_pair.generated_key
    private_key = tls_private_key.key_data.private_key_pem
  } 
  sensitive = true
}