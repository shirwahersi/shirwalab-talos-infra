provider "aws" {
  region = var.region
  default_tags {
    tags = local.envname_tags
  }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/talos-shirwalab"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/talos-shirwalab"
}