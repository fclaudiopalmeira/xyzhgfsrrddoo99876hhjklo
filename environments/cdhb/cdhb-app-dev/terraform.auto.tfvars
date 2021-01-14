## Common Variables
location              = "Australia East" ## This defines the Location of the Infrastructure
Name                  = "cdhb-DW-SAMPLE-Vnet"
resourceGroupName     = "cdhb-DW-SAMPLE-RG" ## This degines the Name of the Resource group
subName               = "cdhb-DW-SAMPLE-subnet"
subnetPrefix          = {
                        "DEV-CDHB-SAMPLE-1-PUB"  = "10.92.1.0/24"
                        "DEV-CDHB-SAMPLE-2-APP"  = "10.92.2.0/24"
                        "DEV-CDHB-SAMPLE-3-DP"  = "10.92.3.0/24"
                        "DEV-CDHB-SAMPLE-4-DG"  = "10.92.4.0/24"
}

common_azure_tags = {
  Terraform-Managed   = "True"
  Environment         = "DEV",
  Business-Unit       = "CDHB",
  Application-Name-ID = "DW-Infra-TEST"
}

## Vm Variables
vmName                = "DEV-cdhb-SAMPLE-vm"
osDiskName            = "DEV-cdhb-SAMPLE-disk"
adminUsername         = "theadmin" ## This defines the Username to login on the VM
adminPassword         = "xfg@@#3456hhJ" ## This defines the password to login on the VM
dnsLabelPrefix        = "DEV-cdhb-SAMPLE"
nicName               = "DEV-cdhb-SAMPLE-Nic"
pipName               = "DEV-cdhb-SAMPLE-PublicIp"
vmSize                = "Standard_D2_v3"
disk_size_gb          = 1023
## Storage Account Variables
replication           = "LRS" ## Possible values are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS, currently LRS is set as the default
tier                  = "Standard" ## Possible values are Standard and Premium, currently Standard is set as the default

## Application variables
ansible               = "yes"
storage_account_type  = "Standard_LRS" ## The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS.

### SQL MANAGD INSTANCES

sqlmi_name            = "DEV-cdhb-SAMPLE-dbsvr"
hop_type              = "internet"