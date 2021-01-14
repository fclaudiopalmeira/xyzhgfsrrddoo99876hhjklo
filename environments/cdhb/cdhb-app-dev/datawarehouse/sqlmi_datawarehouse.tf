## Module to create SQL managed instances calling an ARM template from terraform...WARNING, IT WILL TAKE A LONG TIME TO CREATE THE INSTANCE
### Even though terraform says that it is complete, the ARM template will still be running in the background, and it wll take a long time to run.
module "sqlmi" {
  depends_on = [module.vnet,module.subnet_delegated, module.rgroup, module.storage_acc, module.nsg, module.rt]
  source                          = "../../../../modules/sqlmi"
  location                        = var.location
  resourceGroupName               = module.rgroup.name
  skuName                         = "GP_Gen5"
  skuEdition                      = "GeneralPurpose"
  managedInstanceName             = var.managedInstanceName
  ###managedInstanceTags             = var.common_azure_tags
  administratorLogin              = "azadmin"
  administratorLoginPassword      = "Temp123456!!!!"
  virtualNetworkName              = module.vnet.vnet_name
  subnetid                        = join(",",keys({for subnet in module.subnet_delegated.subnet_delegated_id: subnet.id => subnet if subnet.name == "databricks-CDHB-DEV-2-SQLMI"}))
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