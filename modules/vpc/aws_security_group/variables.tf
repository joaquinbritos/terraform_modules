variable "name" {}

variable "description" {
  default = "Managed by Terraform"
}

variable "vpc_id" {}

variable "tags" {}

variable "sg_ingress_rules" {
  type    = list(any)
  default = []
}

variable "cidr_ingress_rules" {
  type    = list(any)
  default = []
}