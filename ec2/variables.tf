variable "keypair" {}

variable "project_name" {
  type    = string
  default = "default-project"
}

variable "amis" {
  type = map(string)
}

variable "ec2_config" {
  type = map(object({
    instance_type        = string
    region               = string
    availability_zone    = string
    userdata_filename    = string
    private_key_filename = optional(string, "")
    sg_config = object({
      ingress_ports = list(string)
      egress_ports  = list(string)
    })
  }))
}
