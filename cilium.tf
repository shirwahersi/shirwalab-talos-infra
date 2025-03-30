resource "helm_release" "cilium" {
  name = "cilium"

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  namespace  = "kube-system"
  version    = "1.17.2"

  values = ["${file("${path.module}/files/values/cilium.yaml")}"]

  depends_on = [module.talos]

}

# resource "kubernetes_manifest" "cilium_bgp_peering_policy" {
#   manifest = {
#     apiVersion = "cilium.io/v2alpha1"
#     kind       = "CiliumBGPPeeringPolicy"
#     metadata = {
#       name = "talos-cilium-mikrotik"
#     }
#     spec = {
#       nodeSelector = {
#         matchLabels = {
#           "cilium-enable-bgp" = "true"
#         }
#       }
#       virtualRouters = [{
#         localASN      = 64512
#         exportPodCIDR = true
#         neighbors = [{
#           peerAddress = "192.168.88.1/32"
#           peerASN     = 64512
#         }]
#         serviceSelector = {
#           matchExpressions = [{
#             key      = "somekey"
#             operator = "NotIn"
#             values   = ["never-used-value"]
#           }]
#         }
#       }]
#     }
#   }

#   depends_on = [module.talos, helm_release.cilium]
# }

# resource "kubernetes_manifest" "cilium_load_balancer_ip_pool" {
#   manifest = {
#     apiVersion = "cilium.io/v2alpha1"
#     kind       = "CiliumLoadBalancerIPPool"
#     metadata = {
#       name = "talos-mikrotik-lb-pool"
#     }
#     spec = {
#       blocks = [{
#         cidr              = "172.16.88.0/24"
#         allowFirstLastIPs = "No"
#       }]
#     }
#   }
#   depends_on = [module.talos, helm_release.cilium]
# }