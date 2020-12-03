# # This Block outputs the id of the Subnet
/* output "subnet_id" {
  #value = "${azurerm_subnet.as-01.id}"
  value = "${element((azurerm_subnet.as-01[*].id),0)}"
}
 */
/* 
 output "subnet_id" {
  #value = "${azurerm_subnet.as-01.id}"
  value = [
    for id in "${element((azurerm_subnet.as-01[*].id),0)}" :
    azurerm_subnet.as-01.id
    if var.delegated == "no"
  ]
}
 */

output "subnet_id" {
  #value = var.delegated == "no" ? "${element((azurerm_subnet.as-01[*].id),0)}" : null
  value = var.delegated == "no" ? azurerm_subnet.as-01 : {}
  }

/* output "subnet_name" {
  for_each = value = "${azurerm_subnet.as-01[*].name}"
}
 */

output "subnet_delegated_id" {
  #value = var.delegated == "yes" ? "${element((azurerm_subnet.as-02[*].id),0)}" : null
  value = var.delegated == "yes" ? [for s in azurerm_subnet.as-02: s.id] : null
}