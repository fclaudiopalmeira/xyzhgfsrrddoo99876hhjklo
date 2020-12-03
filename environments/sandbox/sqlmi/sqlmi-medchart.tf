## Module to create SQL managed instances calling an ARM template from terraform...WARNING, IT WILL TAKE A LONG TIME TO CREATE THE INSTANCE
### Even though terraform says that it is complete, the ARM template will still be running in the background, and it wll take a long time to run.
 module "sqlmi" {
  depends_on = [module.network, module.rt, module.rgroup, module.storage_acc, module.nsg]
  source                          = "../../../modules/sqlmi"
  location                        = var.location
  resourceGroupName               = module.rgroup.name
  skuName                         = "GP_Gen5"
  skuEdition                      = "GeneralPurpose"
  managedInstanceName             = "testmanagedinstancesandbox"
  managedInstanceTags             = var.common_azure_tags
  administratorLogin              = "medcsql-admin"
  administratorLoginPassword      = "Jw^78jy+gW_tgSYZ9"
  virtualNetworkName              = module.network.vnet_name
  subnetid                        = module.network.subnet_delegated_id
  storageSizeInGB                 = "256"
  vCores                          = "4"
  licenseType                     = "BasePrice"
  hardwareFamily                  = "Gen5"
  dnsZonePartner                  =  ""
  collation                       = "SQL_Latin1_General_CP1_CI_AS"
  proxyOverride                   = "Redirect"
  publicDataEndpointEnabled       = "false"
  minimalTlsVersion               = "1.2"
  timezoneId                      = "New Zealand Standard Time"
 
  ### BELOW ARE THE TAGS, THESE TAGS ARE HERE AS VARIABLES TO BE PUSHED TO THE ARM TEMPLATE
  AppName                         = "MedChart"
  Environment                     = "Dev"
  BillingIdentifier               = "6400506"
  Description                     = "MedChart - electronic medical prescriptions"
  ExpirationDate                  = "undefined"
  MaintenanceWindow               = "undefined"
  Module                          = "SQLMI"
  Organisation                    = "CDHB"
  ProductOwner                    = "Team-ISG-Cap-Meds-EMR@cdhb.health.nz"
  Project                         = "Medchart 2020 Cloud project"
  Tier                            = "DB"
  Vendor                          = "DXC Technology"
} 

### THE PROCESS TO DESTROY:
### - Destroy the SQLMI
### - Run Terraform Destrroy
### THE ORDER IS VERY IMPORTANT

 ##Module to create the vnet and subnet
module "subnet_delegated" {
  source                   = "../../modules/subnet"
  Name                     = module.vnet.vnet_name
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  subnetPrefix             = "20.0.0.0/24"
  nsg_id                   = module.nsg.nsg_id
  delegated                = "yes"
}
 

 ### ROUTE TABLES FOR SQL MANAGED INSTANCES
 module "rt" {
  source                   = "../../modules/rt"
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
}