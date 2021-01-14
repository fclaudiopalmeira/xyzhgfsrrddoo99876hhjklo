## COMMON VARIABLES
variable "resourceGroupName" {
	type        = string
	description = "Resource Group for this deployment."
}

variable "common_azure_tags" {
  type = map(string)
  description = "Common Azure tags to be applied to all created resources."
}

variable "location" {
	type        = string
	description = "Location for all resources"
}

variable "subnet_id" {
	default = null
}

variable "storage_uri" {
	type    		= string
	description = "The Storage Account's Blob Endpoint which should hold the virtual machine's diagnostic files."
}

variable "subnetPrefix" {
	default = null
}

variable "script_name" {
  default     = {}
  description = "Name of the script to be uploaded"
}


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
	type        = string
  ## This is an array, and as such the first value is 0(2016-Datacenter) and the last value is 6(2019-Datacenter)
	#default     = ["2016-Datacenter","2008-R2-SP1","2012-Datacenter","2012-R2-Datacenter","2016-Nano-Server","2016-Datacenter-with-Containers","2019-Datacenter"]
	description = "The Windows version for the VM. This will pick a fully patched image of this given Windows version."
}

variable "vmName" {
	type    		= string
	description = "Name of the virtual machine."
}

variable "subnetplacement" {
  default     = null
  description = "Subnet where the vm will be placed."
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

variable "storage_account_type" {
	type    		= string
	default         = null
	description = "Vm Disk Size"
}