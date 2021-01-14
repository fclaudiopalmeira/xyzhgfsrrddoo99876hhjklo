## Variables to be used exclusively on the subnet module
#The number of subnets to be created is based on this variable
variable "resourceGroupName" {
	type        = string
	#default     = "demo-rg"
	description = "Resource Group for this deployment."
}

/* variable "subnet_names" {
	default = null
}
 */
variable "location" {
	type        = string
	description = "Location of the Resource"
}

variable "subnetPrefix" {
	description = "Map from availability zone to the number that should be used for each availability zone's subnet"
}

variable "nsg_id" {
	type        = string
	description = "Network Security Group ID"
}

variable "delegated" {
	type        = string
	description = "Variable used to determine whether to delegate or not the subnet to the SQL Managed Instance"
}

variable "subnetServiceDelegatedName" {
	default = null
}

variable "vnet_name" {
	type        = string
	description = "Vnet Name"
}

