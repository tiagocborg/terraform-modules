resource "aws_secretsmanager_secret" "secret" {
  name = "${var.name}/db/credentials"
}

resource "aws_secretsmanager_secret_version" "secret_val" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = "{\"DB_NAME\":\"${var.database_name}\", \"DB_USER\":\"${var.username}\",\"DB_PASSWORD\":\"${random_password.master_password.0.result}\",\"DB_HOST\":\"${aws_rds_cluster_instance.this.0.endpoint}\",\"DB_PORT\":\"${aws_rds_cluster_instance.this.0.port}\"}"
}
