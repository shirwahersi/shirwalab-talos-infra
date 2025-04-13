provider "aws" {
  region = var.region
  default_tags {
    tags = local.envname_tags
  }
}

provider "libvirt" {
  uri = "qemu+ssh://root@${var.libvirt_server}/system"
}

provider "routeros" {
  hosturl        = var.mikrotik_router
  username       = jsondecode(data.aws_secretsmanager_secret_version.mikrotik.secret_string)["username"]
  password       = jsondecode(data.aws_secretsmanager_secret_version.mikrotik.secret_string)["password"]
  ca_certificate = "${path.module}/files/mikrotik_cert/server.crt"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}