variable "common_azure_tags" {
  type = map(string)
  description = "Common Azure tags to be applied to all created resources."
}

# Variable declaration
variable "rules" { 
default = {
  }

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

variable "source_port_ranges" { 
default = {}
}

variable "destination_port_ranges" { 
default = {}
}

variable "source_address_prefixes" { 
default = {}
}

variable "destination_address_prefixes" { 
default = {}
}



