
# Resource Group
resource "azurerm_resource_group" "rg-01" {
	name        = var.Name
	location    = var.location
	tags = var.common_azure_tags
}
