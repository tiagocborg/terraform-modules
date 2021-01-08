locals {
  security_group = var.create_sg ? module.sgs.*.sg_id : [var.security_group]
}

resource "aws_db_instance" "this" {
  allocated_storage      = var.snapshot_identifier ? "" : var.allocated_storage
  engine                 = var.snapshot_identifier ? "" : var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.snapshot_identifier ? "" : var.db_name
  username               = var.snapshot_identifier ? "" : var.db_user
  password               = var.snapshot_identifier ? "" : random_password.random_string.result
  vpc_security_group_ids = local.security_group
  db_subnet_group_name   = aws_db_subnet_group.this.name
  identifier             = var.identifier
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible
  tags                   = var.common_tags
  port                   = var.db_port
  parameter_group_name   = var.parameter_group_name
  storage_type           = var.storage_type
  snapshot_identifier    = var.snapshot_identifier
}

module "sgs" {
  count        = var.create_sg ? 1 : 0
  source       = "git::ssh://git@gitlab.com/enxcs/workload/ecs-shared/terraform-modules.git//security_group?ref=v2.3.0"
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

resource "random_password" "random_string" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "secret" {
  name = "${var.project_name}/db/credentials"
}

resource "aws_secretsmanager_secret_version" "secret_val" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = "{\"DB_NAME\":\"${var.db_name}\", \"DB_USER\":\"${var.db_user}\",\"DB_PASSWORD\":\"${random_password.random_string.result}\",\"DB_HOST\":\"${aws_db_instance.this.address}\",\"DB_PORT\":\"${aws_db_instance.this.port}\"}"
}
