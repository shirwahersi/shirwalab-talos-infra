resource "routeros_ip_dhcp_server_lease" "dhcp_lease" {
  for_each    = var.nodes
  address     = each.value.ip
  mac_address = each.value.mac_address
  comment     = "DHCP Lease for ${each.key}"
}