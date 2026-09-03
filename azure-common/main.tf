terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "terraform_state" {
  name     = "rg-terraform-state"
  location = var.location
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "labterraformstate"
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "remote-state"
  storage_account_id    = azurerm_storage_account.terraform_state.id
  container_access_type = "private"
}