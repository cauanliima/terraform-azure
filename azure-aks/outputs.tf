output "aks_name" {
  description = "Nome do cluster AKS"

  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_resource_group" {
  description = "Resource Group do AKS"

  value = azurerm_resource_group.resource_group.name
}

output "aks_node_count" {
  description = "Quantidade de nodes"

  value = var.node_count
}

output "aks_subnet_id" {
  description = "Subnet utilizada pelo AKS"

  value = data.terraform_remote_state.vnet.outputs.subnet_id
}