resource "azurerm_network_security_group" "nsg_1" {
  name                = var.Name
  resource_group_name = var.resourceGroupName
	location            = var.location
}
