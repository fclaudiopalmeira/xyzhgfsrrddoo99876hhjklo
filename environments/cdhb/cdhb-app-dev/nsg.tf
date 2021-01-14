/* 
## Module to create the Network Security group and the rules
 
module "nsg" {
  source                   = "../../modules/nsg"
  location                 = var.location
  resourceGroupName        = module.rgroup.name
  common_azure_tags        = var.common_azure_tags
  Name                     = "bestpracticesNSG"
  rules                    = {
  
    winrm = {
      name                       = "http"
      priority                   = 105
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5986"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    
    
    rdp = {
      name                       = "rdp"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    customapp = {
      name                       = "http"
      priority                   = 104
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8665"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.2.0/24"
    }

    sql = {
      name                       = "sql"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.2.0/24"
    }

    http = {
      name                       = "http"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.2.0/24"
    }
 
	custom_ssh = {
      name                       = "Custom_SSH"
      priority                   = 103
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8052"
      source_address_prefix      = "*"
      destination_address_prefix = "192.168.22.0/24"
    }
  }
} 
 */