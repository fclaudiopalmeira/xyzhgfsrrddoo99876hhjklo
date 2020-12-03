## Common Variables
location              = "Australia East" ## This defines the Location of the Infrastructure
Name                  = "cdhb-demo_Vnet"
resourceGroupName     = "cdhb-demo_RG" ## This degines the Name of the Resource group
subName               = "cdhb-demo_subnet"
subnetPrefix          = {
                        "demosubnet-CDHB-DEV-1-PUB"  = "10.92.1.0/24"
                        "demosubnet-CDHB-DEV-2-APP"  = "10.92.2.0/24"
                        "demosubnet-CDHB-DEV-3-DB"  = "10.92.3.0/24"
}

common_azure_tags = {
  Terraform-Managed   = "True"
  Environment         = "sandbox",
  Business-Unit       = "CDHB",
  Application-Name-ID = "Med-Chart-SQLMI-TEST"
}

## Vm Variables
vmName                = "cdhbbestpracticesvm"
osDiskName            = "cdhbbestpracticesvmdisk"
adminUsername         = "theadmin" ## This defines the Username to login on the VM
adminPassword         = "xfg@@#3456hhJ" ## This defines the password to login on the VM
dnsLabelPrefix        = "cdhbdemodns2020"
nicName               = "cdhbdemoNic"
pipName               = "cdhbPublicIp"
vmSize                = "Standard_D2_v3"
disk_size_gb          = 1023
## Storage Account Variables
replication           = "LRS" ## Possible values are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS, currently LRS is set as the default
tier                  = "Standard" ## Possible values are Standard and Premium, currently Standard is set as the default

## Application variables
ansible               = "yes"
storage_account_type  = "Standard_LRS" ## The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS.

### SQL MANAGD INSTANCES

sqlmi_name            = "caedmedcdbsvr"
hop_type              = "internet"