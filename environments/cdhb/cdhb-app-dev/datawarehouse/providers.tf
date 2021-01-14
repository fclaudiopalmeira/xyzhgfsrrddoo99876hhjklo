provider "azurerm" {
  features {}
}


provider "azurerm" {
  features {}
  alias = "vnet1"
}


provider "azurerm" {
  features {}
  alias = "vnet2"
  subscription_id = "d0773ef0-9668-4c8b-be56-ca3cba530fb3"
}
