module "keypair" {
  count        = var.keypair_module ? 1 : 0
  source       = "./keypair"
  project_name = var.project_name
}

module "ec2" {
  count        = var.ec2_module ? 1 : 0
  source       = "./ec2"
  key_name     = "${var.project_name}-${terraform.workspace}"
  project_name = var.project_name
  keypair      = var.keypair_module ? module.keypair[0].generated_key : null
  amis         = var.amis
  ec2_config   = var.ec2_config
}

module "eip" {
  source  = "./eip"
  eip_new = var.eip_new
  ec2_id  = module.ec2[0].instance_ids[var.eip_instance_name]
  eip_id  = var.eip_id
}

output "instance_ids" {
  value = module.ec2[0].instance_ids
}

output "public_ip" {
  value = module.eip.public_ip
}

output "elastic_ip_id" {
  value = module.eip.elastic_ip_id
}
