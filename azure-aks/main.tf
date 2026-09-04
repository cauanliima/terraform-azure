resource "azurerm_resource_group" "resource_group" {
  name     = "rg-aks"
  location = var.location

  tags = local.common_tags
}



resource "azurerm_user_assigned_identity" "aks" {
  name                = "identity-aks"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  tags = local.common_tags
}


resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = data.terraform_remote_state.vnet.outputs.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  dns_prefix = var.aks_dns_prefix

  default_node_pool {
    name = "system"

    vm_size    = var.node_vm_size
    node_count = var.node_count

    vnet_subnet_id = data.terraform_remote_state.vnet.outputs.subnet_id

    os_disk_size_gb = var.node_os_disk_size_gb

    temporary_name_for_rotation = "systemtmp"

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"

    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  web_app_routing {
    dns_zone_ids = []
  }

  tags = local.common_tags

  depends_on = [
    azurerm_role_assignment.aks_network_contributor
  ]
}