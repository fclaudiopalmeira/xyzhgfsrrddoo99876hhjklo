resource "azurerm_network_security_rule" "nsg_rule" {
  for_each = var.rules
  name                        = "${each.value.name}_port_${each.value.destination_port_range}"
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resourceGroupName
  network_security_group_name = azurerm_network_security_group.nsg_1.name
}
