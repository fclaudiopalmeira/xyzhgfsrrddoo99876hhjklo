variable "remote_resource_group_name" {
  	type        = string
	description = "The resource group name of the remote VNet 2 name"
}

variable "remote_vnet_name" {
  	type        = string
	description = "The remote VNet 2 name"
}

variable "remote_vnet_id" {
  	type        = string
	description = "The peering VNet 2 id"
}

variable "resourceGroupName" {
  	type        = string
	description = "The resource group name of the remote VNet 1 name"
}

variable "vnet_name" {
  	type        = string
	description = "The peering VNet 1 name"
}

variable "vnet_id" {
  	type        = string
	description = "The peering VNet 1 id"
}
