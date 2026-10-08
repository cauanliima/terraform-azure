locals {
  common_tags = {
    owner      = "cauanlima"
    managed-by = "terraform"
    environment = "lab"
    managed_by  = "terraform"
    project     = "aks"
  }
  argocd_hostname = "argocd-${azurerm_public_ip.nginx_ingress.ip_address}.nip.io"
  vault_hostname = "vault-${azurerm_public_ip.nginx_ingress.ip_address}.nip.io"
  grafana_hostname = "grafana-${azurerm_public_ip.nginx_ingress.ip_address}.nip.io"


}