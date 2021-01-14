variable "resourceGroupName" {
	type        = string
	description = "Resource Group for this deployment."
}

variable "location" {
	type        = string
	description = "Location for all resources"
}

variable "virtual_network_id" {
	type        = string
	description = "The public Vnet ID for databrick"
}

variable "public_delegation_subnet_name" {
	type        = string
	description = "The public Subnet name for databrick workspace"
}

variable "private_delegation_subnet_name" {
	type        = string
	description = "The private Subnet name for databrick workspace"
}

variable "common_azure_tags" {
	type        = string
	description = "The workspace resource ID for databrick workspace"
}

variable "storage_account_name" {
	type        = string
	description = "The datawarehouse storage account name"
}

variable "storage_account_primary_access_key" {
	type        = string
	description = "The datawarehouse storage account primary access key"
}

