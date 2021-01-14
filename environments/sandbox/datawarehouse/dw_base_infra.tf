## Module to create the Resource Groups
module "rgroup" {
  source                   = "../../../../modules/rgroup"
  location                 = var.location
  common_azure_tags        = var.common_azure_tags
  Name                     = "cdhb-DW-DEV-RG"
}

## Module to create the Datalake Storage Gen2
module "dlakegen2" {
  source                   = "../../../../modules/dlakestore"
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  common_azure_tags        = var.common_azure_tags

}
## Module to create the Storage Account for the VM
module "storage_acc" {
  source                   = "../../../../modules/storage_acc"
  Name                     = "dwststacc" # As per Azure Standards the name can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  common_azure_tags        = var.common_azure_tags
  replication              = "LRS"
  tier                     = "Standard"
}

##Module to create the Vnet
module "vnet" {
  source                   = "../../../../modules/vnet"
  Name                     = "cdhb-DW-DEV-Vnet"
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  common_azure_tags        = var.common_azure_tags
  addressPrefix            = "10.102.0.0/17"
  dns_servers              = ["10.102.200.4", "10.102.200.6"] #module.vnet_peering.remote_virtual_network_dns_servers
}

##Module to create subnet
module "subnet" {
  source                   = "../../../../modules/subnet"
  vnet_name                = module.vnet.vnet_name
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  subnetPrefix             = var.subnetPrefix
  nsg_id                   = module.nsg.nsg_id
  delegated                = "no"
}

module "from_image" {
  #The licensing should be PAYG for Developer, AHUB for Production respectively using Standard or Enterprise to use on-Prem SQL Licensing
  #THE Image ID must the the ID from within the GAllery, not fro the resource itself
  source                   = "../../../../modules/from_image"
  adminUsername            = "azadmin"
  adminPassword            = "Temp123456!!!!"
  license_type             = "PAYG"
  vmName                   = "c-ae-d-dw-sql"
  disk_name                = "c-ae-d-dw-sql"
  disk_type                = "StandardSSD_LRS"
  vmSize                   = "Standard_E4as_v4"
  image_id                 = "/subscriptions/7f967aac-911a-4928-8103-bfb556469f2b/resourceGroups/c-ae-d-pcs-img-rg/providers/Microsoft.Compute/galleries/c_ae_d_pcs_shd_img_gal/images/c-ae-d-pcs-img-sqlstd2019"
  disk_size_gb             = 1024
  common_azure_tags        = var.common_azure_tags
  pipName                  = "DWPublicIp" ##If a public IP is ever needed, the resource needs to be commented out on the module directly
  resourceGroupName        = module.rgroup.name
  dnsLabelPrefix           = var.dnsLabelPrefix  ### If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
  location                 = var.location
  subnet_id                = module.subnet.subnet_id
  nicName                  = "${var.nicName}-sql"
  subnetplacement          = "databricks-CDHB-DEV-3-APPLICATIONS"

}

/*
## Base Windows VM Module, this creates a base vm according to the chosen windows version
 /* The variable storing the Windows versions is an array, so the versions are ordered like this:
0 - 2016-Datacenter
1 - 2008-R2-SP1
2 - 2012-Datacenter
3 - 2012-R2-Datacenter
4 - 2016-Nano-Server
5 - 2016-Datacenter-with-Containers
6 - 2019-Datacenter"
*/
 
 module "basevm_windows" {
  source                = "../../../../modules/base_vm_windows"
  adminUsername         = "azureadmin"
  adminPassword         = "Temp123456!!!!"
  nicName               = "${var.nicName}-tableau"
  windowsOSVersion      = var.windowsOSVersion[0]
  dnsLabelPrefix        = var.dnsLabelPrefix  ### If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
  pipName               = "cdhbPublicIp" ##If a public IP is ever needed, the resource needs to be commented out on the module directly
  subnet_id             = module.subnet.subnet_id
  vmName                = "c-ae-d-dw-tabl" ## A per Windows limitations, a Windows computer name cannot be more than 15 characters long, be entirely numeric, or contains the following characters "` ~ ! @ # $ % ^ & * ( ) = + _ [ ] { } \\ | ; : . ' \" , < > / ?.""
  vmSize                = "Standard_D2_v3" ### VM sizing can be found here -> https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general?toc=/azure/virtual-machines/linux/toc.json&bc=/azure/virtual-machines/linux/breadcrumb/toc.json
  osDiskName            = "c-ae-d-dw-tabl-disk"
  disk_size_gb          = 1023 ### Specifies the size of the disk in gigabytes.
  storage_uri           = module.storage_acc.uri   ### The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files.
  resourceGroupName     = module.rgroup.name
  location              = var.location
  storage_account_type  = var.storage_account_type  ### WARNING CHANGING THIS AFTER CREATION FORCES A NEW RESOURCE TO BE CREATED, 
                                                   ### possible values can be found on the terraform.auto.tfvars file
  common_azure_tags     = var.common_azure_tags
  script_name           = "scoop.ps1"
  subnetPrefix          = var.subnetPrefix
  subnetplacement       = "databricks-CDHB-DEV-3-APPLICATIONS"
}


 module "basevm_windows2" {
  source                = "../../../../modules/base_vm_windows"
  adminUsername         = "azureadmin"
  adminPassword         = "Temp123456!!!!"
  nicName               = "${var.nicName}-dgw" 
  windowsOSVersion      = var.windowsOSVersion[0]
  dnsLabelPrefix        = "${var.dnsLabelPrefix}-new"  ### If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
  pipName               = "cdhbPublicIp2" ##If a public IP is ever needed, the resource needs to be commented out on the module directly
  subnet_id             = module.subnet.subnet_id
  vmName                = "c-ae-d-dw-dtgw" ## A per Windows limitations, a Windows computer name cannot be more than 15 characters long, be entirely numeric, or contains the following characters "` ~ ! @ # $ % ^ & * ( ) = + _ [ ] { } \\ | ; : . ' \" , < > / ?.""
  vmSize                = "Standard_D2_v3" ### VM sizing can be found here -> https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general?toc=/azure/virtual-machines/linux/toc.json&bc=/azure/virtual-machines/linux/breadcrumb/toc.json
  osDiskName            = "c-ae-d-dw-dtgw-disk"
  disk_size_gb          = 1023 ### Specifies the size of the disk in gigabytes.
  storage_uri           = module.storage_acc.uri   ### The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files.
  resourceGroupName     = module.rgroup.name
  location              = var.location
  storage_account_type  = var.storage_account_type  ### WARNING CHANGING THIS AFTER CREATION FORCES A NEW RESOURCE TO BE CREATED, 
                                                   ### possible values can be found on the terraform.auto.tfvars file
  common_azure_tags     = var.common_azure_tags
  script_name           = "scoop.ps1"
  subnetPrefix          = var.subnetPrefix
  subnetplacement       = "databricks-CDHB-DEV-5-DATA-GATEWAY"
}

## Application Module
## Currently the security protocols defined Windows 2016 and previous version are SSL 3.0 and TLS 1.0. 
## Both of the security protocols are deprecated and it will cause powershell to fail,
## It is advised to run the following commands to enable TLS 1.2 and TLS 1.3 which are the approved protocols at time that this code was written:
## -> Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
## -> Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
## Then run this one to enable the NuGet provider -> Install-Module PowershellGet -Force
 /*
 module "post_inst" {
  source               = "../../../../modules/post_inst"
  depends_on           = [module.basevm_windows]
  count                = lower(var.ansible) == "yes" ? 1 : 0
  resource_group_name  = module.rgroup.name
  virtual_machine_name = module.basevm_windows.virtual_machine_name
  virtual_machine_id   = module.basevm_windows.virtual_machine_id
  #ansible              = var.ansible
  container_name       = "scripts"
  stname               = module.storage_acc.stname
  script_name          = "scoop.ps1"
  script_source        = "../../../scripts/scoop.ps1"
  storage_uri          = module.storage_acc.uri         
} */

module "domain_join" {
  source                      = "../../../../modules/domain_join"
  depends_on                  = [ module.vnet_peering ]
  res_vm_id                   = module.from_image.res_vm_id
  res_ad_domain               = var.res_ad_domain
  res_ad_domain_username      = var.res_ad_domain_username
  res_ad_domain_password      = var.res_ad_domain_password
  res_active_directory_OUPath = var.res_active_directory_OUPath
  common_azure_tags           = var.common_azure_tags
}


module "domain_join_tabl" {
  source                      = "../../../../modules/domain_join"
  depends_on                  = [ module.vnet_peering ]
  res_vm_id                   = module.basevm_windows.virtual_machine_id
  res_ad_domain               = var.res_ad_domain
  res_ad_domain_username      = var.res_ad_domain_username
  res_ad_domain_password      = var.res_ad_domain_password
  res_active_directory_OUPath = var.res_active_directory_OUPath
  common_azure_tags           = var.common_azure_tags
}

module "vnet_peering" {
  source                     = "../../../../modules/vnet_peering"
  depends_on                  = [ module.vnet ]
  remote_resource_group_name = var.remote_resource_group_name
  remote_vnet_name           = var.remote_vnet_name
  remote_vnet_id             = var.remote_vnet_id  
  resourceGroupName          = module.rgroup.name
  vnet_name                  = module.vnet.vnet_name
  vnet_id                    = module.vnet.vnet_id
  ### Providers with Alias
  providers = {
    azurerm.vnet2 = azurerm.vnet2
    azurerm.vnet1 = azurerm.vnet1
  }
}
# to be built

##Module to create the vnet and subnet
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

/* module "databricks" {
  depends_on                  = [ module.subnet_delegated ]
  source                   = "../../../../modules/databricks"
  resourceGroupName                   = module.rgroup.name
  location                            = var.location
  virtual_network_id                  = module.vnet.vnet_id
  #public_delegation_subnet_name         = module.subnet.public_delegation_subnet_name #(TBC)
  #private_delegation_subnet_name        = module.subnet.private_delegation_subnet_name #(TBC)
  common_azure_tags                   = var.common_azure_tags
  storage_account_name                = module.dlakegen2.storage_account_name
  storage_account_primary_access_key  = module.dlakegen2.primary_access_key
}
 */
