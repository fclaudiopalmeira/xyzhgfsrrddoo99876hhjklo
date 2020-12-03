# # This Block outputs the name of the Resource Group
output "name" {
  value = "${azurerm_resource_group.rg-01.name}"
}
