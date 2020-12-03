module "steves_rgroup" {
  source                   = "../../modules/rgroup"
  location                 = var.location
  Name                     = "steves_rgroup"
}


module "basevm_windows" {
  source               = "../../modules/base_vm_windows"
  adminUsername        = "theadmin"
  adminPassword        = "xfg@@#3456hhJ"
  nicName              = var.nicName
  windowsOSVersion     = var.windowsOSVersion
  dnsLabelPrefix       = var.dnsLabelPrefix  ### If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
  pipName              = "cdhbPublicIp"
  subnet_id            = module.network.subnet_id
  vmName               = "bestpractdemovm" ## A per Windows limitations, a Windows computer name cannot be more than 15 characters long, be entirely numeric, or contains the following characters "` ~ ! @ # $ % ^ & * ( ) = + _ [ ] { } \\ | ; : . ' \" , < > / ?.""
  vmSize               = "Standard_D2_v3" ### VM sizing can be found here -> https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general?toc=/azure/virtual-machines/linux/toc.json&bc=/azure/virtual-machines/linux/breadcrumb/toc.json
  osDiskName           = "bestpracticesvmdisk"
  disk_size_gb         = 1023 ### Specifies the size of the disk in gigabytes.
  storage_uri          = module.storage_acc.uri   ### The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files.
  resourceGroupName    = module.rgroup.name
  location             = var.location
  storage_account_type = var.storage_account_type  ### WARNING CHANGING THIS AFTER CREATION FORCES A NEW RESOURCE TO BE CREATED, 
                                                   ### possible values can be found on the terraform.auto.tfvars file
}