resource "helm_release" "nfs-csi-driver" {
  name = "csi-driver-nfs"

  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart      = "csi-driver-nfs"
  namespace  = "kube-system"
  version    = "v4.12.1"

  values     = ["${file("${path.module}/files/helm/csi-driver-nfs/nfs-csi-driver-values.yaml")}"]
}