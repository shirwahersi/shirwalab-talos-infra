data "aws_secretsmanager_secret" "acme-update-key" {
  name = "/homelab/ipa/acme-update-key"
}

data "aws_secretsmanager_secret_version" "acme-update-key" {
  secret_id = data.aws_secretsmanager_secret.acme-update-key.id
}