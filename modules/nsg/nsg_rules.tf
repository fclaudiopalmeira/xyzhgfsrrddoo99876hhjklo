resource "azurerm_network_security_rule" "nsg_rule" {
  depends_on = [azurerm_network_security_group.nsg_1]
  for_each = var.rules
  name                          = "${each.value.name}"
  direction                     = each.value.direction
  access                        = each.value.access
  priority                      = each.value.priority
  protocol                      = each.value.protocol
  source_port_range             = each.value.source_port_range
  source_port_ranges            = each.value.source_port_ranges
  destination_port_range        = each.value.destination_port_range
  destination_port_ranges       = each.value.destination_port_ranges
  source_address_prefix         = each.value.source_address_prefix
  source_address_prefixes       = each.value.source_address_prefixes
  destination_address_prefix    = each.value.destination_address_prefix
  destination_address_prefixes  = each.value.destination_address_prefixes
  resource_group_name           = var.resourceGroupName
  network_security_group_name   = var.Name
}