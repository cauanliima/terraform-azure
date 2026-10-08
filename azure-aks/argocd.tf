resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace        = "argocd"
  create_namespace = true

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
          "server.disable.auth" = true
        }
      }

      server = {
        service = {
          type = "ClusterIP"
        }

        ingress = {
          enabled          = true
          ingressClassName = "nginx"

          hostname = local.argocd_hostname

          path     = "/"
          pathType = "Prefix"

          tls = false
        }
      }
    })
  ]

  depends_on = [
    helm_release.nginx_ingress
  ]
}