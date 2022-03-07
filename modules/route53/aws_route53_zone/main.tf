resource "aws_route53_zone" "main" {
  count         = var.is_in_vpc ? 0 : var.is_public ? 0 : var.create_zone ? 1 : 0
  name          = var.name
  comment       = var.comment
  tags          = var.tags
  force_destroy = var.force_destroy
}

resource "aws_route53_zone" "main_in_vpc" {
  count         = var.is_in_vpc && var.create_zone ? 1 : 0
  name          = var.name
  comment       = var.comment
  tags          = var.tags
  force_destroy = var.force_destroy
  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.vpc_region
  }
}

resource "aws_route53_zone" "main_public" {
  count             = var.is_public && var.create_zone ? 1 : 0
  name              = var.name
  comment           = var.comment
  tags              = var.tags
  delegation_set_id = var.delegation_set_id
  force_destroy     = var.force_destroy
}

