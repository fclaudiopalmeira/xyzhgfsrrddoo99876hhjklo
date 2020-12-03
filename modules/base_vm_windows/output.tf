# # This Block outputs the id of the Subnet
output "virtual_machine_name" {
  value = "${azurerm_windows_virtual_machine.avm-01.name}"
}

output "virtual_machine_id" {
  value = "${azurerm_windows_virtual_machine.avm-01.id}"
}