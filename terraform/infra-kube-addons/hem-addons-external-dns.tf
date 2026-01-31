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

resource "kubernetes_secret_v1" "external_dns_cf_api" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace.external_dns.metadata[0].name
  }

  data = {
    cloudflare_token = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["cloudflare_token"]
  }
}

resource "kubernetes_secret_v1" "external_dns_bind_tsig" {
  metadata {
    name      = "bind-tsig-secret"
    namespace = kubernetes_namespace.external_dns.metadata[0].name
  }

  data = {
    externaldns = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["dns_hmac_sha512"]
  }
}

resource "helm_release" "external-dns-bind" {
  name = "external-dns-bind"

  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = kubernetes_namespace.external_dns.metadata[0].name
  create_namespace = false
  version          = "1.19.0"

  values = ["${file("${path.module}/files/helm/external-dns/external-dns-bind-value.yaml")}"]

}

# resource "helm_release" "external-dns-cloudflare" {
#   name = "external-dns-cloudflare"

#   repository       = "https://kubernetes-sigs.github.io/external-dns/"
#   chart            = "external-dns"
#   namespace        = kubernetes_namespace.external_dns.metadata[0].name
#   create_namespace = false
#   version          = "1.19.0"

#   values = ["${file("${path.module}/files/helm/external-dns/external-dns-cloudflare.yaml")}"]

# }
