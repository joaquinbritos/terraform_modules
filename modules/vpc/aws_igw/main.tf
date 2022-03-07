locals {
  igw_name = "${var.environment}-${var.name}-igw"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      "Name" = format("%s", local.igw_name)
    },
    var.identifier_tags,
  )
}

