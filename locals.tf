locals {
  envname_tags = {
    envname = var.envname
    group   = "infrastructure"
    stack   = "shirwalab-talos-infra"
  }
}
