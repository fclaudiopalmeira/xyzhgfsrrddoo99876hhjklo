### ROUTE TABLES FOR SQL MANAGED INSTANCES
/* module "rt" {
  source                   = "../../modules/rt"
  location                 = var.location
  sqlmi_name               = var.sqlmi_name
  common_azure_tags        = var.common_azure_tags
  resourceGroupName        = module.rgroup.name
  subnetid                 = module.network.subnet_id
  routes                   = {
  
    routesJumpboxes = {
      name                 = "routesJumpboxes"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.sqlmi_name}"
      address_prefix       = "65.55.188.0/24"
      next_hop_type        = "${var.hop_type}"
    }

    routesSAW_1 = {
      name                 = "SqlManagement_supportability_1"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.sqlmi_name}"
      address_prefix       = "207.68.190.32/27"
      next_hop_type        = "${var.hop_type}"
    }

    routesSAW_2 = {
      name                 = "SqlManagement_supportability_2"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.sqlmi_name}"
      address_prefix       = "13.106.78.32/27"
      next_hop_type        = "${var.hop_type}"
    }

    routesSAW_3 = {
      name                 = "SqlManagement_supportability_3"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.sqlmi_name}"
      address_prefix       = "13.106.174.32/27"
      next_hop_type        = "${var.hop_type}"
    }

    routesSAW_4 = {
      name                 = "SqlManagement_supportability_4"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.sqlmi_name}"
      address_prefix       = "13.106.4.96/27"
      next_hop_type        = "${var.hop_type}"
    }

  }
} */
## Module to create the Resource Group
module "base_rg" {
  source                   = "../../modules/rgroup"
  location                 = var.location
  Name                     = "c-ae-d-infr-rg"
}

## Module to create the Storage Account for the VM
/* module "storage_acc" {
  source                   = "../../modules/storage_acc"
  Name                     = "stevetestSA" # As per Azure Standards the name can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  replication              = "LRS"
  tier                     = "Standard"
}
 */

##Module to create the vnet and subnet
module "base_vnet" {
 for each = 
 source                   = "../../modules/network"
  Name                     = "base_vnet"
  resourceGroupName        = module.base_rgroup.name
  location                 = var.location
  addressPrefix            = "10.92.0.0/16"     ## DEV VNET - Mostly confirmed
  subnetPrefix             = "10.92.0.0/20" ## subnets need to be sorted here
  nsg_id                   = module.base_nsg.nsg_id
  delegated                = "no"
}

## Module to create the Network Security group and the rules

module "base_nsg" {
  source                   = "../../modules/nsg"
  location                 = var.location
  resourceGroupName        = module.rgroup.name
  Name                     = "stevetestNSG"
  rules                    = {
  
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


## FOR FUTURE KUBERNETES DEPLOYMENTS ##

#### AKS CLUSTER #####

# WARNING -> ACTIVATE THIS ONLY IF AN AKS Exclusive Service Principal Is NEEDED

/* module "aks_identities" {
  source       = "../../modules/aks_identities"
  cluster_name = var.cluster_name
}
 */
# AKS Log Analytics
/*
module "log_analytics" {
  source                           = "../../modules/log_analytics"
  resource_group_name              = module.rgroup.name
  log_analytics_workspace_location = var.log_analytics_workspace_location
  log_analytics_workspace_name     = var.log_analytics_workspace_name
  log_analytics_workspace_sku      = var.log_analytics_workspace_sku
}


# AKS Cluster

module "aks_cluster" {
  source                   = "../../modules/aks-cluster"
  cluster_name             = var.cluster_name
  location                 = var.location
  dns_prefix               = var.dns_prefix
  resource_group_name      = module.rgroup.name
  kubernetes_version       = var.kubernetes_version
  node_count               = var.node_count
  min_count                = var.min_count
  max_count                = var.max_count
  os_disk_size_gb          = "1028"
  max_pods                 = "110"
  vm_size                  = var.vm_size
  vnet_subnet_id           = module.network.subnet_id
  ### client_id                = module.aks_identities.cluster_client_id
  ### client_secret            = module.aks_identities.cluster_sp_secret
  diagnostics_workspace_id = module.log_analytics.azurerm_log_analytics_workspace
}
*/