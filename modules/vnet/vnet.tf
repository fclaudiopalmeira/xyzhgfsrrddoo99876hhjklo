# Virtual Network
resource "azurerm_virtual_network" "avn-01" {
	name                = var.Name
	resource_group_name = var.resourceGroupName
	location            = var.location
	address_space       = [var.addressPrefix]
}
