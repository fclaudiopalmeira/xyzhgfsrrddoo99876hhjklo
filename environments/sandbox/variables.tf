# Tags applied to all created resources
variable "common_azure_tags" {
  type = map(string)
  description = "Common Azure tags to be applied to all created resources."
}

variable "sqlmi_name" {
 description = "variable used to pass the SQLMI names to the ARM templates"
}

variable "routes" {
default = {
  }
}

## COMMON VARIABLES
/*02.
variable "Name" {
	type        = string
	description = "Name of this resource."
}
*/
variable "resourceGroupName" {
	type        = string
	description = "Resource Group for this deployment."
}

variable "location" {
	type        = string
	description = "Location for all resources"
}

####### NETWORK VARIABLES  #######
variable "rules" { 
default =  {
  }

}

variable "hop_type" {
	type        = string
	description = "Next Hop Type for the Route"
}

variable "subnet_id" {
	default = null
}

variable "subnetNameDelegated" {
	default = null
}

variable "subnetPrefix" {
  description = "Map from availability zone to the number that should be used for each availability zone's subnet"
  default     = ""
}

/* 
variable "delegated" {
	type        = string
	description = "Variable used to determine whether to delegate or not the subnet to the SQL Managed Instance"
} */
## VM VARIABLES
variable "adminUsername" {
	type        = string
	default     = "demo_user"
	description = "Username for the Virtual Machine."
}

variable "adminPassword" {
	type        = string
	description = "Password for the Virtual Machine."
}

variable "dnsLabelPrefix" {
	type        = string
	default     = "demodns2020"
	description = "Unique DNS Name for the Public IP used to access the Virtual Machine."
}

variable "windowsOSVersion" {
	type        = list(string)
  ## This is an array, and as such the first value is 0(2016-Datacenter) and the last value is 6(2019-Datacenter)
	default     = ["2016-Datacenter","2008-R2-SP1","2012-Datacenter","2012-R2-Datacenter","2016-Nano-Server","2016-Datacenter-with-Containers","2019-Datacenter"]
	description = "The Windows version for the VM. This will pick a fully patched image of this given Windows version."
}

variable "vmName" {
	type    		= string
	description = "Size of the virtual machine."
}


variable "vmSize" {
	type    		= string
	default 		= "Standard_A2_v2"
	description = "Size of the virtual machine."
}

variable "nicName" {
	type    		= string
	description = "Size of the virtual machine."
}

variable "pipName" {
	type    		= string
	description = "Size of the virtual machine."
}

variable "osDiskName" {
	type    		= string
	description = "Vm Disk Name"
}

variable "disk_size_gb" {
	type    		= string
	description = "Vm Disk Size"
}

variable "storage_uri" {
	type    		= string
	default         = null
	description = "The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files."
}

variable "storage_account_type" {
	type    		= string
	default         = null
	description = "Vm Disk Size"
}

## STORAGE ACCOUNT VARIABLES
variable "replication" {
	type        = string
	description = "Replication type for the Storage Account"
}

variable "tier" {
	type        = string
	description = "Storage account tier"
}

### APP VARIABLES

variable "ansible" {
  description = "Specifies the operating system type."
}

variable "virtual_machine_name" {
  description = "The name of the virtual machine."
  default     = null
}

variable "virtual_machine_id" {
  description = "The id of the virtual machine."
  default     = null
}

variable "script" {
  default     = null
  description = "Script to be executed."
}


#### VARIABLES FOR THE CONTAINER TO STORE THE SCRIPT

variable "container_name" {
  default     = {}
  description = "The name of the container to store the scripts."
}

variable "stname" {
  default     = {}
  description = "Name of the storage account"
}

variable "script_name" {
  default     = {}
  description = "Name of the script to be uploaded"
}

variable "script_source" {
  default     = {}
  description = "Source script to be uploaded"
}


#### VARIABLES FOR THE AKS CLUSTER #####

variable "node_count" {
  description = "number of nodes to deploy"
  default     = 2
}

variable "dns_prefix" {
  description = "DNS Suffix"
  default     = "cdhbcloud"
}

variable cluster_name {
  description = "AKS cluster name"
  default     = "cdhbcloud"
}

variable log_analytics_workspace_name {
  default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions Coming on Q3 2020 for Australia Central 2
variable log_analytics_workspace_location {
  default = "australiaeast"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing Coming on Q3 2020 for Australia Central 2
variable log_analytics_workspace_sku {
  default = "PerGB2018"
}

variable kubernetes_version {
  description = "version of the kubernetes cluster"
  default     = "1.17.11"
}

variable "vm_size" {
  description = "size/type of VM to use for nodes"
  default     = "Standard_D2_v2"
}

variable "os_disk_size_gb" {
  description = "size of the OS disk to attach to the nodes"
  default     = 512
}

variable "max_pods" {
  description = "maximum number of pods that can run on a single node"
  default     = "100"
}

variable "address_space" {
  description = "The address space that is used the virtual network"
  default     = "10.2.0.0/16"
}
variable "min_count" {
  default     = 1
  description = "Minimum Node Count"
}
variable "max_count" {
  default     = 2
  description = "Maximum Node Count"
}













