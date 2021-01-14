variable "common_azure_tags" {
  type = map(string)
  description = "Common Azure tags to be applied to all created resources."
}

variable "resourceGroupName" {
	type        = string
	#default     = "demo-rg"
	description = "Resource Group for this deployment."
}

variable "Name" {
	type        = string
	#default     = "demo-rg"
	description = "Name of this resource."
}

variable "location" {
	type        = string
	description = "Location of the Resource"
}

variable "addressPrefix" {
	type        = string
	description = "Address prefix"
}
variable "dns_servers" {
  	type        = list
	description = "The list of dns servers from the remote VNet"
}