variable "image" {
  description = "Talos image configuration"
  type = object({
    factory_url  = optional(string, "https://factory.talos.dev")
    schematic    = string
    version      = string
    arch         = optional(string, "amd64")
    platform     = optional(string, "metal")
    image_type   = optional(string, "iso")
    datastore_id = optional(string, "iso")
  })
}

variable "cluster" {
  description = "Cluster configuration"
  type = object({
    name            = string
    endpoint        = string
    gateway         = string
    talos_version   = string
    libvirt_cluster = string
  })
}

variable "nodes" {
  description = "Configuration for cluster nodes"
  type = map(object({
    machine_type      = string
    datastore_id      = optional(string, "default")
    ip                = string
    mac_address       = string
    enable_qemu_agent = optional(bool, true)
    cpu               = number
    memory            = number
    disk_size         = number
  }))
  default = {}
}
