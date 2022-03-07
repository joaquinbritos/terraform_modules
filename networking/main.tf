# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.67.0"
#     }
#   }
# }

locals {

  name_prefix = "${var.environment}-${var.application}"
  user_tag    = var.user != "" ? { Owner = var.user } : {}
  team_tag    = var.team != "" ? { Team = var.team } : {}

  tags = merge({
    Environment = var.environment
    Region      = var.region
    Terraform   = true
    },
    local.user_tag,
    local.team_tag
  )
}

## VPC

module "vpc" {
  source               = "../modules/vpc/aws_vpc"
  environment          = var.environment
  name                 = var.application
  # user                 = var.user
  cidr_block           = var.vpc_cidr_block
  identifier_tags      = local.tags
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
}

# ## INTERNET GATEWAY

# module "internet_gateway" {
#   source          = "../modules/vpc/aws_igw"
#   environment     = var.environment
#   name            = var.application
#   identifier_tags = local.tags
#   vpc_id          = module.vpc.id
# }

# ## NAT GATEWAY

# module "nat_gateway" {
#   source         = "../modules/vpc/aws_nat_gw"
#   environment    = var.environment
#   nat_subnet_ids = module.public_subnet.subnet_ids
#   name           = local.name_prefix
#   ngw_count      = length(var.availability_zones)
#   vpc_id         = module.vpc.id
# }

# ## VPC ENDPOINT

# module "s3_vpc_endpoint" {
#   count               = var.s3_vpce ? 1 : 0
#   source              = "../modules/vpc/aws_vpc_service_endpoint"
#   enable_vpc_endpoint = "1"
#   vpc_id              = module.vpc.id
#   service             = "com.amazonaws.${var.region}.s3"
# }

# ## SUBNETS

# module "public_subnet" {
#   source                 = "../modules/vpc/aws_subnet_setup"
#   name                   = local.name_prefix
#   gw_count               = length(var.availability_zones)
#   gw_id                  = module.internet_gateway.igw_id
#   vpc_id                 = module.vpc.id
#   available_az           = var.availability_zones
#   is_public              = true
#   subnet_count           = length(var.availability_zones)
#   user                   = var.user
#   environment            = var.environment
#   subnet_size            = var.subnet_size
#   cidr_block             = module.vpc.cidr_block
#   subnet_assignment_list = split(",", lookup(var.subnet_assignment, "public", 0))
#   subnet_type            = "public"
#   identifier_tags        = local.tags
#   s3_vpc_endpoint_id     = var.s3_vpce ? module.s3_vpc_endpoint[0].vpc_endpoint_id : ""
#   enable_s3_vpc_endpoint = var.s3_vpce
# }

# module "application_subnet" {
#   source                 = "../modules/vpc/aws_subnet_setup"
#   name                   = local.name_prefix
#   vpc_id                 = module.vpc.id
#   available_az           = var.availability_zones
#   subnet_count           = length(var.availability_zones)
#   user                   = var.user
#   environment            = var.environment
#   subnet_size            = var.subnet_size
#   cidr_block             = module.vpc.cidr_block
#   subnet_assignment_list = split(",", lookup(var.subnet_assignment, "application", 0))
#   subnet_type            = "application"
#   identifier_tags        = local.tags
#   s3_vpc_endpoint_id     = var.s3_vpce ? module.s3_vpc_endpoint[0].vpc_endpoint_id : ""
#   ngw_id_list            = module.nat_gateway.ngw_ids
#   is_public              = false
#   ngw_count              = length(var.availability_zones)
#   enable_s3_vpc_endpoint = var.s3_vpce
# }

# module "persistence_subnet" {
#   source                 = "../modules/vpc/aws_subnet_setup"
#   name                   = local.name_prefix
#   vpc_id                 = module.vpc.id
#   available_az           = var.availability_zones
#   subnet_count           = length(var.availability_zones)
#   user                   = var.user
#   environment            = var.environment
#   subnet_size            = var.subnet_size
#   cidr_block             = module.vpc.cidr_block
#   subnet_assignment_list = split(",", lookup(var.subnet_assignment, "persistence", 0))
#   subnet_type            = "persistence"
#   identifier_tags        = local.tags
#   s3_vpc_endpoint_id     = var.s3_vpce ? module.s3_vpc_endpoint[0].vpc_endpoint_id : ""
#   ngw_id_list            = module.nat_gateway.ngw_ids
#   is_public              = false
#   ngw_count              = length(var.availability_zones)
#   enable_s3_vpc_endpoint = var.s3_vpce
# }

# ## SUBNETS GROUPS

# resource "aws_db_subnet_group" "item" {
#   name       = "${local.name_prefix}-db-subnet-group"
#   subnet_ids = module.persistence_subnet.subnet_ids
#   tags       = local.tags
# }

# # DNS PRIVATE HOSTZONE

# module "private_hostedzone" {
#   source      = "../modules/route53/aws_route53_zone"
#   create_zone = true
#   name        = var.dns_private_domain
#   tags        = local.tags
#   vpc_id      = module.vpc.id
#   is_in_vpc   = true
#   is_public   = false
# }

# ## SECURITY GROUPS

# module "alb_security_group" {
#   source = "../modules/vpc/aws_security_group"
#   vpc_id = module.vpc.id
#   name   = "${local.name_prefix}-alb-sg"
#   cidr_ingress_rules = [{
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     }, {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]
#   tags = local.tags
# }

# module "ec2_bastion_security_group" {
#   source = "../modules/vpc/aws_security_group"
#   vpc_id = module.vpc.id
#   name   = "${local.name_prefix}-ec2-bastion-sg"
#   cidr_ingress_rules = [{
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]
#   tags = local.tags
# }

# ## LOAD BALANCER

# data "aws_acm_certificate" "issued" {
#   domain   = var.dns_public_domain
# }

# module "alb" {
#   source             = "../modules/lb/aws_alb"
#   name               = "${local.name_prefix}-alb"
#   load_balancer_type = "application"
#   tags               = local.tags
#   vpc_id             = module.vpc.id
#   subnets            = module.public_subnet.subnet_ids
#   security_groups    = ["${module.alb_security_group.this_security_group_id}"]

#   # access_logs = {
#   #   bucket = "my-alb-logs"
#   # }

#   target_groups = [
#     {
#       name             = "${local.name_prefix}-tg"
#       backend_protocol = "HTTP"
#       backend_port     = 80
#       target_type      = "ip"
#     }
#   ]

#   https_listeners = [
#     {
#       port               = 443
#       protocol           = "HTTPS"
#       certificate_arn    = data.aws_acm_certificate.issued.arn
#       target_group_index = 0
#     }
#   ]

#   http_tcp_listeners = [
#     {
#       port               = 80
#       protocol           = "HTTP"
#       target_group_index = 0
#     }
#   ]
# }

# ## KEY-PAIR

# module "key_pair" {
 
#   source     = "../modules/key-pair"
#   key_name   = "${local.name_prefix}-bastion"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1+q4pW66GJNE2UxWMPecZ/KMUDIOBMsk1G78kYaykatJjETJnMFwzkuUG0CwRfN2aZhM/c1Kh9cBn7pTyV+6EIrThiz3TG/w8IWFUjswavc3irBO12grnlbKaiKJ/UCrfGMEQxtd4AaTCAIosEZ+fb7cDeucep7ZUY0nWlBtKKKODoa7v8L9V9nij0wyV314iC+QclObkRrzIztOsAJPjkQHznMy3pXTXdT+A/AFlDN9TJCShseeJNL/frjT1XEQxEWZJNjmdZ5O8sd84CIg2x8XbWUuFGZ7VfOdFEqNxpzFjB6KvTCE3pxKqPyudIl9YDHzyWhyX51LMBY/rJ//GBk69svCByd+23toONjiLfGmlfKisp5orITTnxNtTtRiFZBfVcLQYPtlDitUknF0tBvPSNuXngui61ZlXifmt3cZIHaoNvGVfVvGoRGCLbKFjFPbQULFFBMg19EMf8gInZeolo8jv6YNh7AnZgjNdbDW+f+uTnsAOQCO1Icgl4rNZJeCd+zgnZ7HeyLu+4EX+hd9E7OECtrNUXMz1hQjdLKXRUl9p1bm5GM3P6jVAjGxFdGIdlgfJj6xasysrsAOgS1RDEeBVsxB2M+PawOPskKut8X4O+0H/d/ZMHsMvlS5bJ4p356p/wKIpBi1YP+4UEu1NxTvUW4vxgT4qilm43w== user@Scripto"

# }

# ## EC2 BASTION

# module "ec2_bastion_instance" {

#   source     = "../modules/ec2"
#   name                           = "${local.name_prefix}-bastion"
#   ami                            = var.ec2_bastion_ami
#   instance_type                  = var.ec2_bastion_instance_type
#   key_name                       = "${local.name_prefix}-bastion"
#   monitoring                     = var.ec2_bastion_monitoring
#   vpc_security_group_ids         = ["${module.ec2_bastion_security_group.this_security_group_id}"]
#   subnet_id                      = element(module.public_subnet.subnet_ids, 0)
#   associate_public_ip_address    = true
#   volume_tags                    = local.tags
#   tags                           = local.tags
# }

# ## ELASTIC IP EC2 BASTION

# resource "aws_eip" "bastion" {
#   instance = module.ec2_bastion_instance.id
#   vpc      = true
#   tags     = local.tags
# }