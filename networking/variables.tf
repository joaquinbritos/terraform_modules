## TAGS
variable "user" {
  type = string
}

variable "team" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "application" {
  type = string
}

## VPC
variable "vpc_cidr_block" {
  type = string
}

variable "availability_zones" {
  type = list(any)
}

variable "subnet_size" {
  type = string
}

variable "subnet_assignment" {
  type = map(string)

  default = {
    "public"      = "0,1"
    "application" = "2,3"
    "persistence" = "4,5"
  }
}

variable "s3_vpce" {
  type    = bool
  default = false
}

## DNS
variable "dns_private_domain" {
  type = string
}

variable "dns_public_domain" {
  type = string
}

## EC2 BASTION

variable "ec2_bastion_ami" {
  type = string
}

variable "ec2_bastion_instance_type" {
  type = string
}

variable "ec2_bastion_monitoring" {
  type = bool
}