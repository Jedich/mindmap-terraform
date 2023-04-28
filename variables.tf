variable "project_name" {
  type    = string
  default = "default-project"
}

variable "amis" {
  type = map(string)
  default = {
    eu-central-1 = "ami-06616b7884ac98cdd"
    eu-west-1    = "ami-08fea9e08576c443b"
    eu-west-2    = "ami-0055e70f580e9ae80"
    eu-west-3    = "ami-09352f5c929bf417c"
  }
}

variable "ec2_config" {
  type = map(object({
    instance_type        = string
    region               = string
    availability_zone    = string
    userdata_filename    = string
    private_key_filename = optional(string, "")
    sg_config = object({
      ingress_ports = optional(list(string), [])
      egress_ports  = optional(list(string), [])
    })
  }))
  default = {
    "ec2" = {
      instance_type = "t2.micro"
      region = "eu-central-1"
      availability_zone = "eu-central-1c"
      userdata_filename = "user-data.txt"
      sg_config = {}
    }
  }
}

variable "keypair_module" {
  type    = bool
  default = true
}

variable "ec2_module" {
  type    = bool
  default = true
}


variable "eip_instance_name" {
  type = string
}

variable "eip_id" {
  type = string
  default = ""
}

variable "eip_new" {
  type    = bool
  default = true
}