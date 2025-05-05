resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_secret_v1" "argocd_acme" {
  metadata {
    name      = "ipa-tsig-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  data = {
    rfc2136_tsig_secret = data.aws_secretsmanager_secret_version.acme-update-key.secret_string
  }
}

resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false
  version          = "7.9.0"
  values           = ["${file("${path.module}/files/helm/argocd/argocd-values.yaml")}"]
}

resource "kubernetes_secret_v1" "argocd_app_secret" {
  metadata {
    name      = "argocd-oidc-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = {
      "app.kubernetes.io/name"    = "argocd-oidc-secret"
      "app.kubernetes.io/part-of" = "argocd"
    }
  }

  data = {
    "oidc.azure.clientSecret" = jsondecode(data.aws_secretsmanager_secret_version.entra-id.secret_string)["argocd_client_secret"]
  }
}