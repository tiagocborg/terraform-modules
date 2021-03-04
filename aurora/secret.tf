resource "aws_secretsmanager_secret" "secret" {
  name = "${var.project_name}/db/credentials"
}

resource "aws_secretsmanager_secret_version" "secret_val" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = "{\"DB_NAME\":\"${var.db_name}\", \"DB_USER\":\"${var.db_user}\",\"DB_PASSWORD\":\"${random_password.master_password.result}\",\"DB_HOST\":\"${aws_rds_cluster_instance.this.endpoint}\",\"DB_PORT\":\"${aws_rds_cluster_instance.this.port}\"}"
}
