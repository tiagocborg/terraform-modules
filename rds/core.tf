locals {
  security_group = var.create_sg ? [module.sgs.sg_id] : [var.security_group]
}

resource "aws_db_instance" "this" {
  allocated_storage      = 20
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.db_name
  username               = var.db_user
  password               = var.db_password
  vpc_security_group_ids = local.security_group
  db_subnet_group_name   = aws_db_subnet_group.this.name
  identifier             = var.identifier
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible
  tags                   = var.common_tags
  port                   = var.db_port
}

module "sgs" {
  count        = var.create_sg ? 1 : 0
  source       = "git::ssh://git@gitlab.com/enxcs/workload/ecs-shared/terraform-modules.git//security_group?ref=v1.0.7"
  project_name = var.project_name
  description  = "${var.project_name} RDS security group"
  vpc_id       = var.vpc_id
  sg_rules     = var.sg_rules
  common_tags  = var.common_tags
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-rds-subnet-group"
  subnet_ids = var.subnets

  tags = merge(
    {
      Name = "${var.project_name}-rds-subnet-group"
    },
    var.common_tags
  )
}
