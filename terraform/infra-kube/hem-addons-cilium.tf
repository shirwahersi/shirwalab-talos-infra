resource "helm_release" "cilium" {
  name = "cilium"

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  namespace  = "kube-system"
  version    = "1.17.2"

  values = ["${file("${path.module}/files/values/helm/cilium/cilium.yaml")}"]

  depends_on = [module.talos]
}

resource "helm_release" "cilium-bgp" {
  name = "cilium-bgp"

  repository = "./charts"
  chart      = "cilium-bgp"
  namespace  = "kube-system"
  version    = "0.1.0"

  set = [{
    name  = "peerAddress"
    value = "${var.gateway_ip}/32"
    },
    {
      name  = "localASN"
      value = var.bgp_asn
    },
    {
      name  = "peerASN"
      value = var.bgp_asn
    },
    {
      name  = "cidr"
      value = var.cilium_ip_pool_cidr
    }
  ]

  depends_on = [helm_release.cilium]
}

resource "routeros_routing_bgp_connection" "talos_mikrotik_bgp_connection" {
  for_each         = var.nodes
  name             = "${each.key}-k8s-mikrotik_bgp-peering"
  as               = var.bgp_asn
  address_families = "ip"
  local {
    role = "ibgp"
  }
  remote {
    address = each.value.ip
  }
}