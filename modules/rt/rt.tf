resource "azurerm_route_table" "sqlmi" {
  name                          = "rt-${var.sqlmi_name}"
  location                      = var.location
  resource_group_name           = var.resourceGroupName
  disable_bgp_route_propagation = false
  tags = merge(
    var.common_azure_tags,
    {
      "tag1"       = "tag1",
      "Managed By" = "Terraform - Pipeline from Azure"
    }
  )
}

### We need to pass the SQLMI instance name as a variable to the arm template

resource "azurerm_route" "sqlmir" {
  depends_on = [azurerm_route_table.sqlmi]
  for_each            = var.routes
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  route_table_name    = each.value.route_table_name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type
}

### Associates the route table with the subnet

resource "azurerm_subnet_route_table_association" "sqlmi" {
  subnet_id      = var.subnetid
  route_table_id = azurerm_route_table.sqlmi.id
}







