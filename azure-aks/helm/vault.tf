resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.28.1"

  namespace        = "vault"
  create_namespace = true

  values = [
    yamlencode({
      injector = {
        agentDefaults = {
          cpuLimit   = "500m"
          cpuRequest = "0m"
          memLimit   = "128Mi"
          memRequest = "64Mi"
        }
      }

      server = {
        ingress = {
          enabled          = true
          ingressClassName = "nginx"

          hosts = [
            {
              host = local.vault_hostname
            }
          ]
        }

        service = {
          type     = "NodePort"
          nodePort = 30280
        }

        dev = {
          enabled      = true
          devRootToken = "cauan@123"
        }
      }
    })
  ]

  depends_on = [
    helm_release.nginx_ingress
  ]
}