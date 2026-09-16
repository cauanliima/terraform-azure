resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        replicaCount = 2

        service = {
          type = "LoadBalancer"
          externalTrafficPolicy = "Cluster"
          annotations = {
            "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz"
            "service.beta.kubernetes.io/azure-pip-name" = azurerm_public_ip.nginx_ingress.name
            "service.beta.kubernetes.io/azure-load-balancer-resource-group" = azurerm_resource_group.resource_group.name
            }
        }
        networkPolicy = {
          enabled = true
        }
      }
    })
  ]

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    azurerm_role_assignment.aks_public_ip_network_contributor,
    azurerm_public_ip.nginx_ingress
  ]
}