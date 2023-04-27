variable "name" {
  type    = string
  default = "default-security-group"
}

variable "ingress_ports" {
  type    = list(string)
  default = ["22"]
}

variable "egress_ports" {
  type = list(string)
}
