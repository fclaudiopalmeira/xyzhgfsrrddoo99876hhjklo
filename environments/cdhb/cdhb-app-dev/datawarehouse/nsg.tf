## Module to create the Network Security group and the rules

## For the purpose to pass the variable into the map object "rules" in module "nsg"
### The Address Prefixes of the delegated and non-delegated subnets
locals {
    subnetAddrDelegated    = flatten([for name, value in var.subnetNameDelegated: value.address_prefixes])                                                          
    subnetAddrNonDelegated = flatten([for name, value in var.subnetPrefix: value])                      
}
### The combined Address Prefixes list of all datawarehouse subnets
locals {
      subnetAddrPrefixes   = flatten([local.subnetAddrDelegated, local.subnetAddrNonDelegated])
}

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
  databricksvnet = {
      name                         = "databricksvnet"
      priority                     = 3008
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "*"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    }
    databricksnoscc = {
      name                         = "databricksnoscc"
      priority                     = 3009
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "22"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    }
    databricksnoscc2 = {
      name                         = "databricksnoscc2"
      priority                     = 3010
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "icmp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "5557"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      source_address_prefixes      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    }
    
    ### Allow inbound geodr traffic inside the virtual network
    allowgeodrinbound = {
      name                         = "allowgeodrinbound"
      priority                     = 3011
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "5022"
      destination_port_ranges      = null
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = null
      destination_address_prefixes = local.subnetAddrPrefixes
    }
    ### Allow outbound geodr traffic inside the virtual network
    allowgeodroutbound = {
      name                         = "allowgeodroutbound"
      priority                     = 3012
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "5022"
      destination_port_ranges      = null
      source_address_prefix        = null
      source_address_prefixes      = local.subnetAddrPrefixes
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    }
    ### Allow inbound redirect traffic to Managed Instance inside the virtual network
    allowredirectinbound = {
      name                         = "allowredirectinbound"
      priority                     = 3013
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "11000-11999"
      destination_port_ranges      = null
      source_address_prefix        = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefix   = null
      destination_address_prefixes = local.subnetAddrPrefixes
    }
    ### Allow outbound redirect traffic to Managed Instance inside the virtual network
    allowredirectoutbound = {
      name                         = "allowredirectoutbound"
      priority                     = 3014
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "tcp"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = "11000-11999"
      destination_port_ranges      = null
      source_address_prefix        = null
      source_address_prefixes      = local.subnetAddrPrefixes
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    }     
  }
} 
