variable "common_azure_tags" {
  type = map(string)
  description = "Common Azure tags to be applied to all created resources."
}

variable "location" {
	type        = string
	default     = ""
	description = "Location for all resources"
}

variable "Name" {
	type        = string
	default     = ""
	description = "Name of the resource Group"
}