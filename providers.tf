provider "aws" {
  region = var.region
  default_tags {
    tags = local.envname_tags
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}