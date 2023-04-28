resource "aws_eip" "lb" {
  count    = var.eip_new ? 1 : 0
  instance = var.ec2_id
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  count         = var.eip_new ? 0 : 1
  instance_id   = var.ec2_id
  allocation_id = var.eip_id
}

output "elastic_ip_id" {
  value = var.eip_new ? resource.aws_eip.lb[0].allocation_id : var.eip_id
}

output "public_ip" {
  value = var.eip_new ? resource.aws_eip.lb[0].public_dns : resource.aws_eip_association.eip_assoc[0].public_ip
}