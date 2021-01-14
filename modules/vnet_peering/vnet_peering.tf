/* resource "azurerm_virtual_network_peering" "vnet-1" {
  name                      = "peer1to2"
  resource_group_name       = var.resourceGroupName
  virtual_network_name      = var.vnet_name
  remote_virtual_network_id = var.remote_vnet_id
}

resource "azurerm_virtual_network_peering" "vnet-2" {
  name                      = "peer2to1"
  resource_group_name       = var.remote_resource_group_name
  virtual_network_name      = var.remote_vnet_name
  remote_virtual_network_id = var.vnet_id
}

## For future use, to automatically get the data from the remote vnet
data "azurerm_virtual_network" "remote-vnet" {
  name                = var.remote_vnet_name
  resource_group_name = var.remote_resource_group_name
}
 */

 data "azurerm_virtual_network" "vnet" {
  provider            = azurerm.vnet1
  name                = var.vnet_name
  resource_group_name = var.resourceGroupName
}

data "azurerm_virtual_network" "remote" {
  provider            = azurerm.vnet2
  name                = var.remote_vnet_name
  resource_group_name = var.remote_resource_group_name
}

resource "azurerm_virtual_network_peering" "peering" {
  provider            = azurerm.vnet1
  name                         = "${data.azurerm_virtual_network.vnet.name}-to-${data.azurerm_virtual_network.remote.name}"
  resource_group_name          = var.resourceGroupName
  virtual_network_name         = data.azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.remote.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # Allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "peering1" {
  provider = azurerm.vnet2
  name                         = "${data.azurerm_virtual_network.remote.name}-to-${data.azurerm_virtual_network.vnet.name}"
  resource_group_name          = var.remote_resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.remote.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # Allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = true
}