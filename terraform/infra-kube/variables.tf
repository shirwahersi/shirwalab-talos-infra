variable "envname" {}

variable "region" {
  default = "eu-west-2"
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

variable "gateway_ip" {
  type        = string
  description = "Gateway IP / Mikrotek router"
  default     = "192.168.88.1"
}

variable "bgp_asn" {
  type        = string
  description = "Cilium Mikrotek BGP ASN number"
  default     = "64512"
}

variable "cilium_ip_pool_cidr" {
  type    = string
  default = "172.16.88.0/24"
}

variable "libvirt_server" {
  type        = string
  description = "Home Lab KVM server"
  default     = "server.int.shirwalab.net"
}

variable "mikrotik_router" {
  type    = string
  default = "https://mikrotik.int.shirwalab.net"
}
