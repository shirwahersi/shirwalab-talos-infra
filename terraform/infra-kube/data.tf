data "aws_secretsmanager_secret" "mikrotik" {
  name = "mikrotik"
}

data "aws_secretsmanager_secret_version" "mikrotik" {
  secret_id = data.aws_secretsmanager_secret.mikrotik.id
}