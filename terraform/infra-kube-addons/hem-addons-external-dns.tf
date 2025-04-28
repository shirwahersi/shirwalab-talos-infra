resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret_v1" "external_dns_ns_acme-update" {
  metadata {
    name      = "ipa-tsig-secret"
    namespace = kubernetes_namespace.external_dns.metadata[0].name
  }

  data = {
    rfc2136_tsig_secret = data.aws_secretsmanager_secret_version.acme-update-key.secret_string
  }
}

resource "helm_release" "external-dns" {
  name = "external-dns"

  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = kubernetes_namespace.external_dns.metadata[0].name
  create_namespace = false
  version          = "8.3.9"

  values = ["${file("${path.module}/files/helm/external-dns/external-dns-values.yaml")}"]

}
