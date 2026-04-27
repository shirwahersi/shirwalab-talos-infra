resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = kubernetes_namespace.cert_manager.metadata[0].name
  create_namespace = false
  version          = "v1.19.0"

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

resource "kubernetes_secret_v1" "cloudflare_api" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  data = {
    api_token = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["cloudflare_token"]
  }
}

resource "kubernetes_secret_v1" "vault_app_role" {
  metadata {
    name      = "vault-app-role"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  data = {
    cert_manager_role_id = jsondecode(data.aws_secretsmanager_secret_version.vault.secret_string)["cert_manager_role_id"]
    cert_manager_role_secret_id = jsondecode(data.aws_secretsmanager_secret_version.vault.secret_string)["cert_manager_role_secret_id"]
  }
}

resource "kubernetes_manifest" "cert_manager_cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "vault-issuer"
    }
    spec = {
      vault = {
        path  = "shirwalab/pki_int/sign/cert-manager"
        server = "https://vault.int.shirwalab.net"
        caBundle = "${base64encode(file("${path.module}/files/ca/shirwalab_ca.crt"))}"
        auth = {
          appRole = {
            path: "approle"
            roleId = "cab5f6ae-693a-7f85-0fb5-9e475e6a2344"
            secretRef = {
              name = kubernetes_secret_v1.vault_app_role.metadata[0].name
              key  = "cert_manager_role_secret_id"
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.cert]
}

resource "kubernetes_manifest" "letsencrypt_cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "admin@shirwalab.net"
        privateKeySecretRef = {
          name = "letsencrypt-cloudflare-key"
        }
        solvers = [{
          dns01 = {
            cloudflare = {
              email = "admin@shirwalab.net" 
              apiTokenSecretRef = {
                name = kubernetes_secret_v1.cloudflare_api.metadata[0].name
                key  = "api_token"
              }
            }
          }
        }]
      }
    }
  }
  depends_on = [helm_release.cert]
}