# Subnet Creation
### NON-DELEGATED SUBNET, SUITED FOR GENERAL USE
resource "azurerm_subnet" "as-01" {
	for_each = var.delegated  == "no" ? var.subnetPrefix : {}
    name                       = each.key
	resource_group_name        = var.resourceGroupName
	virtual_network_name       = var.vnet_name
	address_prefixes           = [each.value]

}

### DELEGATED SUBNET, SUITED FOR USE WITH SQL MANAGED INSTANCES
resource "azurerm_subnet" "as-02" {
	count                      = lower(var.delegated) == "yes" ? 1 : 0
    name                       = var.subName
	resource_group_name        = var.resourceGroupName
	virtual_network_name       = var.vnet_name
	address_prefixes           = [var.subnetPrefix]

	
    delegation {
    name = "acctestdelegation"

    service_delegation {
      name    = "Microsoft.Sql/managedInstances"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

# Associate subnet and network security group with non delegated subnet 
resource "azurerm_subnet_network_security_group_association" "asnsga-01" {
	for_each                    = var.delegated  == "no" ? azurerm_subnet.as-01 : {}
	subnet_id                   = azurerm_subnet.as-01[each.key].id
	network_security_group_id   = var.nsg_id
}

# Associate subnet and network security group with delegated subnet
resource "azurerm_subnet_network_security_group_association" "asnsga-02" {
	count                      = lower(var.delegated) == "yes" ? 1 : 0
	subnet_id                   = element(azurerm_subnet.as-02[*].id, 0)
	network_security_group_id   = var.nsg_id
}