resource "aws_security_group" "this" {
  name        = var.name
  vpc_id      = var.vpc_id
  description = var.description

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(tomap({"Name" = var.name}), var.tags)
}

resource "aws_security_group_rule" "cidr_rule" {
  count       = length(var.cidr_ingress_rules)
  type        = "ingress"
  from_port   = var.cidr_ingress_rules[count.index].from_port
  to_port     = var.cidr_ingress_rules[count.index].to_port
  protocol    = var.cidr_ingress_rules[count.index].protocol
  cidr_blocks = var.cidr_ingress_rules[count.index].cidr_blocks

  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "sg_rule" {
  count                    = length(var.sg_ingress_rules)
  type                     = "ingress"
  from_port                = var.sg_ingress_rules[count.index].from_port
  to_port                  = var.sg_ingress_rules[count.index].to_port
  protocol                 = var.sg_ingress_rules[count.index].protocol
  source_security_group_id = var.sg_ingress_rules[count.index].security_groups[0]

  security_group_id = aws_security_group.this.id
}