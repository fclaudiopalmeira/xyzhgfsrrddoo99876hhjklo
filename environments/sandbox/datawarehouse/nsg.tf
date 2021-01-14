## Module to create the Network Security group and the rules
 
module "nsg" {
  source                   = "../../../../modules/nsg"
  location                 = var.location
  resourceGroupName        = module.rgroup.name
  Name                     = "DWNSG"
  common_azure_tags        = var.common_azure_tags
  rules                    = {
  rdp = {
      name                         = "a_ib_rdp"
      priority                     = 3000
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "3389"
      destination_port_ranges      = null
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }

    sccm = {
      name                         = "a_ib_sccm"
      priority                     = 3001
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "*"
      destination_port_ranges      = null
      source_address_prefix        = null
      source_address_prefixes      = ["172.30.4.207/32","172.30.4.103/32"]
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }

	  winrm = {
      name                         = "a_ib_winrm"
      priority                     = 3002
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "5985-5986"
      destination_port_ranges      = null
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }

    allowsql = {
      name                         = "a_ib_sql"
      priority                     = 3003
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "1433"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }

    allowhttp = {
      name                         = "a_ib_80"
      priority                     = 3004
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "80"
      destination_port_ranges      = null
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }

    allowhttps = {
      name                         = "a_ib_443"
      priority                     = 3005
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "443"
      destination_port_ranges      = null
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }
/* 
    blockall = {
      name                         = "BlockAll"
      priority                     = 3006
      direction                    = "Inbound"
      access                       = "Deny"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "*"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }  
 */
	icmp = {
      name                         = "icmp"
      priority                     = 3007
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "icmp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "*"
      destination_port_ranges      = null
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = "*"
      destination_address_prefixes = null
    }
  }
} 
