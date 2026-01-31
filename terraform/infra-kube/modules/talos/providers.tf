terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.88.0"
    }
  }
}
