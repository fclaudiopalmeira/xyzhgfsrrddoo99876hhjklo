# # This Block outputs the name of the Network Security Group
output "nsg_id" {
  value = "${azurerm_network_security_group.nsg_1.id}"
}
