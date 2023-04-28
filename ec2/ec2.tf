resource "aws_instance" "instance" {
  for_each          = var.ec2_config
  ami               = var.amis[each.value.region]
  instance_type     = each.value.instance_type
  availability_zone = each.value.availability_zone
  key_name          = var.key_name
  security_groups   = [module.sg[each.key].security_group]
  tags = {
    Name = "${var.project_name}-${each.key}-${terraform.workspace}"
  }
  user_data = file(each.value.userdata_filename)
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.keypair.private_key
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "./user_data/init/deploy.sh"
    destination = "/home/ec2-user/deploy.sh"
  }
  provisioner "file" {
    source      = "./user_data/init/docker-compose.yaml"
    destination = "/home/ec2-user/docker-compose.yaml"
  }
  provisioner "file" {
    source      = "./user_data/init/docker-pwd.txt"
    destination = "/home/ec2-user/docker-pwd.txt"
  }
}

module "sg" {
  source        = "../secgroup"
  for_each      = var.ec2_config
  name          = "${var.project_name}-${each.key}-"
  ingress_ports = each.value.sg_config.ingress_ports
  egress_ports  = each.value.sg_config.egress_ports
}

output "instance_ids" {
  value = {
    for k, v in aws_instance.instance : k => v.id
  }
}
