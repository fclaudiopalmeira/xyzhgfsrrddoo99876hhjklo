
## Module to create the Resource Group
module "rgroup" {
  source                   = "../../modules/rgroup"
  location                 = var.location
  Name                     = "bestpracticestestRG"
}

## Module to create the Storage Account for the VM
module "storage_acc" {
  source                   = "../../modules/storage_acc"
  Name                     = "bestpracticesteststacc" # As per Azure Standards the name can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  replication              = "LRS"
  tier                     = "Standard"
}

##Module to create the Vnet
module "vnet" {
  source                   = "../../modules/vnet"
  Name                     = "bestpracticestestvnet-CDHB-DEV"
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  addressPrefix            = "10.92.0.0/16"
}

##Module to create subnet
module "subnet" {
  source                   = "../../modules/subnet"
  vnet_name                = module.vnet.vnet_name
  resourceGroupName        = module.rgroup.name
  location                 = var.location
  subnetPrefix             = var.subnetPrefix
  nsg_id                   = module.nsg.nsg_id
  delegated                = "no"
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
  source                = "../../modules/base_vm_windows"
  adminUsername         = "theadmin"
  adminPassword         = "xfg@@#3456hhJ"
  nicName               = var.nicName
  windowsOSVersion      = var.windowsOSVersion[0]
  dnsLabelPrefix        = var.dnsLabelPrefix  ### If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
  pipName               = "cdhbPublicIp"
  subnet_id             = module.subnet.subnet_id
  vmName                = "bestpracticesvm" ## A per Windows limitations, a Windows computer name cannot be more than 15 characters long, be entirely numeric, or contains the following characters "` ~ ! @ # $ % ^ & * ( ) = + _ [ ] { } \\ | ; : . ' \" , < > / ?.""
  vmSize                = "Standard_D2_v3" ### VM sizing can be found here -> https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general?toc=/azure/virtual-machines/linux/toc.json&bc=/azure/virtual-machines/linux/breadcrumb/toc.json
  osDiskName            = "bestpracticesvmdisk"
  disk_size_gb          = 1023 ### Specifies the size of the disk in gigabytes.
  storage_uri           = module.storage_acc.uri   ### The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files.
  resourceGroupName     = module.rgroup.name
  location              = var.location
  storage_account_type  = var.storage_account_type  ### WARNING CHANGING THIS AFTER CREATION FORCES A NEW RESOURCE TO BE CREATED, 
                                                   ### possible values can be found on the terraform.auto.tfvars file
  subnetPrefix          = var.subnetPrefix
}

## Application Module
## Currently the security protocols defined Windows 2016 and previous version are SSL 3.0 and TLS 1.0. 
## Both of the security protocols are deprecated and it will cause powershell to fail
## It is advised to run the following commands to enable TLS 1.2 and TLS 1.3 which are the approved protocols at time that this code was written:
## -> Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
## -> Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
## Then run this one to enable the NuGet provider -> Install-Module PowershellGet -Force
  module "ansible_prep" {
  source               = "../../modules/ansible_prep"
  count                = lower(var.ansible) == "yes" ? 1 : 0
  resource_group_name  = module.rgroup.name
  virtual_machine_name = module.basevm_windows.virtual_machine_name
  virtual_machine_id   = module.basevm_windows.virtual_machine_id
  #ansible              = var.ansible
  container_name       = "scripts"
  stname               = module.storage_acc.stname
  script_name          = "ansible.ps1"
  script_source        = "../../modules/ansible_prep/files/ansible.ps1"
  storage_uri          = module.storage_acc.uri         
}

#### AKS CLUSTER #####

# WARNING -> ACTIVATE THIS ONLY IF AN AKS Exclusive Service Principal Is NEEDED

/* module "aks_identities" {
  source       = "../../modules/aks_identities"
  cluster_name = var.cluster_name
}
 */
# AKS Log Analytics

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
  vnet_subnet_id           = module.subnet.subnet_id
  ### client_id                = module.aks_identities.cluster_client_id
  ### client_secret            = module.aks_identities.cluster_sp_secret
  diagnostics_workspace_id = module.log_analytics.azurerm_log_analytics_workspace
}
