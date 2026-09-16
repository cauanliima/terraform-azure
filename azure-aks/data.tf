data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "labterraformstate"
    container_name       = "remote-state"
    key                  = "azure-vnet/terraform.tfstate"
  }
  
}

data "azurerm_network_security_group" "terraform" {
  name                = "nsg-terraform"
  resource_group_name = "rg-vnet"
}