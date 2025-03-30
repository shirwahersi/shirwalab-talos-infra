provider "aws" {
  region = var.region
  default_tags {
    tags = local.envname_tags
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

provider "routeros" {
  hosturl        = "https://192.168.88.1"
  username       = jsondecode(data.aws_secretsmanager_secret_version.mikrotik.secret_string)["username"]
  password       = jsondecode(data.aws_secretsmanager_secret_version.mikrotik.secret_string)["password"]
  ca_certificate = "${path.module}/certs/server.crt"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/talos-shirwalab"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/talos-shirwalab"
}