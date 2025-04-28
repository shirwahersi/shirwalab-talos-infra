resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_config_map_v1" "ipa-ca-bundle" {
  metadata {
    name      = "ipa-ca-bundle"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  data = {
    "ca-certificates.crt" = "${file("${path.module}/files/helm/cert-manager/ipa-ca.crt")}"
  }
}

resource "helm_release" "cert" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  create_namespace = false
  version          = "v1.17.2"

  values = ["${file("${path.module}/files/helm/cert-manager/cert-manager-values.yaml")}"]
}

resource "kubernetes_secret_v1" "acme-update" {
  metadata {
    name      = "ipa-tsig-secret"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  data = {
    rfc2136_tsig_secret = data.aws_secretsmanager_secret_version.acme-update-key.secret_string
  }
}

resource "kubernetes_manifest" "cert_manager_cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "ipa"
    }
    spec = {
      acme = {
        email  = "admin@int.shirwalab.net"
        server = "https://idm.int.shirwalab.net/acme/directory"
        privateKeySecretRef = {
          name = "ipa-issuer-account-key"
        }
        solvers = [{
          dns01 = {
            rfc2136 = {
              nameserver    = "idm.int.shirwalab.net"
              tsigKeyName   = "acme-update"
              tsigAlgorithm = "HMACSHA512"
              tsigSecretSecretRef = {
                name = "ipa-tsig-secret"
                key  = "rfc2136_tsig_secret"
              }
            }
          }
          selector = {
            dnsZones = ["int.shirwalab.net"]
          }
        }]
      }
    }
  }

  depends_on = [helm_release.cert]
}
