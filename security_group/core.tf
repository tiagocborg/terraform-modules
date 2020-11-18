resource "aws_security_group" "this" {
  name_prefix = "${var.project_name}-"
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.common_tags
}

resource "aws_security_group_rule" "ingress_rule" {
  count             = length(var.sg_rules)
  security_group_id = aws_security_group.this.id
  type              = lookup(var.sg_rules[count.index], "type")
  from_port         = lookup(var.sg_rules[count.index], "from_port")
  to_port           = lookup(var.sg_rules[count.index], "to_port")
  cidr_blocks       = lookup(var.sg_rules[count.index], "cidr_blocks")
  protocol          = lookup(var.sg_rules[count.index], "protocol")
  description       = lookup(var.sg_rules[count.index], "description")
}
