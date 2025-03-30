resource "libvirt_volume" "node" {
  for_each = var.nodes
  name     = "${each.key}.qcow2"
  size     = each.value.disk_size
  pool     = each.value.datastore_id
}

resource "libvirt_domain" "talos_controlplane" {
  for_each  = var.nodes
  name      = each.key
  memory    = each.value.memory
  vcpu      = each.value.cpu
  autostart = true

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    bridge         = "bridge0"
    mac            = each.value.mac_address
    wait_for_lease = true
  }

  boot_device {
    dev = ["hd", "cdrom"]
  }

  disk {
    file = libvirt_volume.boot_image.id

  }

  disk {
    volume_id = libvirt_volume.node[each.key].id
  }

  qemu_agent = each.value.enable_qemu_agent

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
    source_path = "/dev/pts/2"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}