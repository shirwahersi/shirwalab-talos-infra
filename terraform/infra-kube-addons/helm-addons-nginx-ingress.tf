resource "helm_release" "ingress-nginx-internal" {
  name = "ingress-nginx-internal"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "kube-system"
  version    = "4.13.3"

  set = [{
    name  = "controller.ingressClassResource.name"
    value = "nginx-internal"
    },
    {
      name  = "controller.ingressClassResource.controllerValue"
      value = "k8s.io/nginx-internal"
    },
  ]
}

resource "helm_release" "ingress-nginx-external" {
  name = "ingress-nginx-external"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "kube-system"
  version    = "4.13.3"

  set = [{
    name  = "controller.ingressClassResource.name"
    value = "nginx-external"
    },
    {
      name  = "controller.ingressClassResource.controllerValue"
      value = "k8s.io/nginx-external"
    },
  ]
}