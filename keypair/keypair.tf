locals {
  key_name       = "${var.project_name}-${terraform.workspace}"
  keypair_exists = fileexists("input/key/${local.key_name}.pem") && fileexists("input/key/${local.key_name}.pub")
  public_key     = local.keypair_exists ? file("input/key/${local.key_name}.pub") : ""
  private_key    = local.keypair_exists ? file("input/key/${local.key_name}.pem") : ""
}

resource "tls_private_key" "key_data" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = local.key_name
  public_key = local.keypair_exists ? local.public_key : tls_private_key.key_data.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content         = local.keypair_exists ? local.private_key : tls_private_key.key_data.private_key_pem
  filename        = "output/key/${local.key_name}.pem"
  file_permission = "0600"
}

resource "local_sensitive_file" "public_key" {
  content         = local.keypair_exists ? local.public_key : tls_private_key.key_data.public_key_openssh
  filename        = "output/key/${local.key_name}.pub"
  file_permission = "0600"
}

output "generated_key" {
  value = {
    public_key  = local.keypair_exists ? file("input/key/${local.key_name}.pub") : tls_private_key.key_data.public_key_openssh
    private_key = local.keypair_exists ? file("input/key/${local.key_name}.pem") : tls_private_key.key_data.private_key_pem
  }
  sensitive = true
}
