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
        }
      }

      server = {
        service = {
          type = "ClusterIP"
        }

        ingress = {
          enabled          = true
          ingressClassName = "webapprouting.kubernetes.azure.com"

          hostname = "argocd-52.224.79.13.nip.io"

          path     = "/"
          pathType = "Prefix"

          tls = false
        }
      }
    })
  ]
}