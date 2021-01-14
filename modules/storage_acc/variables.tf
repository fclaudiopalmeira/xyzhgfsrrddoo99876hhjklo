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
	#default     = ""
	description = "Location of the Resource"
}

variable "replication" {
	type        = string
	#default     = ""
	description = "Replication type for the Storage Account"
}

variable "tier" {
	type        = string
	#default     = ""
	description = "Storage account tier"
}