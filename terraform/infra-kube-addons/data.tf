data "aws_secretsmanager_secret" "acme-update-key" {
  name = "/homelab/ipa/acme-update-key"
}

data "aws_secretsmanager_secret_version" "acme-update-key" {
  secret_id = data.aws_secretsmanager_secret.acme-update-key.id
}

data "aws_secretsmanager_secret" "entra-id" {
  name = "/homelab/entra-id/secrets"
}

data "aws_secretsmanager_secret_version" "entra-id" {
  secret_id = data.aws_secretsmanager_secret.entra-id.id
}