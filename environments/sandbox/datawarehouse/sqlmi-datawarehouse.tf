## Module to create SQL managed instances calling an ARM template from terraform...WARNING, IT WILL TAKE A LONG TIME TO CREATE THE INSTANCE
### Even though terraform says that it is complete, the ARM template will still be running in the background, and it wll take a long time to run.
 module "sqlmi" {
  depends_on = [module.vnet,module.subnet, module.rgroup, module.storage_acc, module.nsg]
  source                          = "../../../../modules/sqlmi"
  location                        = var.location
  resourceGroupName               = module.rgroup.name
  skuName                         = "GP_Gen5"
  skuEdition                      = "GeneralPurpose"
  managedInstanceName             = "c-ae-d-dw-sqlmi"
  ###managedInstanceTags             = var.common_azure_tags
  administratorLogin              = "azadmin"
  administratorLoginPassword      = "Temp123456!!!!"
  virtualNetworkName              = module.vnet.vnet_name
  subnetid                        = module.subnet.subnet_delegated_id
  storageSizeInGB                 = "4096"
  vCores                          = "32"
  licenseType                     = "BasePrice"
  hardwareFamily                  = "Gen5"
  dnsZonePartner                  =  ""
  collation                       = "SQL_Latin1_General_CP1_CI_AS"
  proxyOverride                   = "Redirect"
  publicDataEndpointEnabled       = "false"
  minimalTlsVersion               = "1.2"
  timezoneId                      = "New Zealand Standard Time"
 
  ### BELOW ARE THE TAGS, THESE TAGS ARE HERE AS VARIABLES TO BE PUSHED TO THE ARM TEMPLATE
  Organisation                    = "CDHB"
  Environment                     = "Dev"
  BillingIdentifier               = "6400932"
  AppName                         = "ModernDW"
  Description                     = "Decision Support Modern Data Warehouse"
}

### THE PROCESS TO DESTROY:
### - Destroy the SQLMI
### - Run Terraform Destrroy
### THE ORDER IS VERY IMPORTANT

/* ##Module to create the vnet and subnet
module "subnet_delegated" {
  source                   = "../../../../modules/subnet"
  vnet_name                = module.vnet.vnet_name
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  nsg_id                   = module.nsg.nsg_id
  delegated                = "yes"
  subnet_names              = var.subnetNameDelegated  
  subnetServiceDelegatedName = var.subnetServiceDelegatedName
  #subnetPrefix             = "10.102.34.0/23"
}
 */

/* module "subnet_delegated2" {
  source                   = "../../../../modules/subnet"
  vnet_name                = module.vnet.vnet_name
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  #subnetPrefix             = "10.102.34.0/23"
  nsg_id                   = module.nsg.nsg_id
  delegated                = "yes"
  subnet_names             = var.subnetNameDelegated
} */

 ##### ROUTE TABLES FOR SQL MANAGED INSTANCES
/* module "rt" {
  source                   = "../../../../modules/rt"
  location                 = var.location
  sqlmi_name               = var.sqlmi_name
  common_azure_tags        = var.common_azure_tags
  resourceGroupName        = module.rgroup.name
  subnetid                 = module.subnet.subnet_id
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