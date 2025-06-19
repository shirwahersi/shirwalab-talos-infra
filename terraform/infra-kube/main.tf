module "talos" {
  source = "./modules/talos"

  providers = {
    routeros = routeros
  }

  image = {
    version   = "v1.10.4"
    schematic = file("${path.module}/files/image/schematic.yaml")
  }

  cluster = {
    name            = "talos-shirwalab"
    endpoint        = [for k, v in var.nodes : v.ip if v.machine_type == "controlplane"][0]
    gateway         = var.gateway_ip
    talos_version   = "v1.10.4"
    libvirt_cluster = "shirwalab"
  }

  nodes = var.nodes
}