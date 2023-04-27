module "keypair" {
  source       = "./keypair"
  project_name = var.project_name
  count        = var.keypair_module ? 1 : 0
}

module "ec2" {
  count        = var.ec2_module ? 1 : 0
  source       = "./ec2"
  project_name = var.project_name
  keypair      = var.keypair_module ? module.keypair[0].generated_key : null
  amis         = var.amis
  ec2_config   = var.ec2_config
}

resource "aws_eip" "lb" {
  instance = module.ec2[0].instance_ids[var.eip_instance_name]
  vpc      = true
}

output "instance_ids" {
  value = module.ec2[0].instance_ids
}

output "public_ip" {
  value = resource.aws_eip.lb.public_dns
}
