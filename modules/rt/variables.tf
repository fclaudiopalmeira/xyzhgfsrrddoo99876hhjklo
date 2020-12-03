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
 description = "Name of the routes for the routing table"
}

variable "subnetid" {
description = "Subnet ID"
    
}

variable "location" {
 description = "variable used to pass the rgroup location"
}

variable "resourceGroupName" {
	type        = string
	description = "Resource Group for this deployment."
}
/*
variable "Name" {
 description = "variable used to pass the SQLMI names to the ARM templates"
}
*/
/* variable "hop_type" {
	type        = string
	description = "Next Hop Type for the Route"
} */


### SQLMI SERVER NAMES, it needs to have rt infront of it -> dev = caedmedcdbsvr, uat = caeumedcdbsvr, prod = caepmedcdbsvr
