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