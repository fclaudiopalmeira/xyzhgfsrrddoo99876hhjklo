variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "virtual_machine_name" {
  description = "The name of the virtual machine."
}

variable "virtual_machine_id" {
  description = "The id of the virtual machine."
  default     = null
}
/* 
variable "ansible" {
  description = "Specifies the operating system type."
}
 */
variable "command" {
  default     = ""
  description = "Command to be executed."
}

variable "script" {
  default     = ""
  description = "Script to be executed."
}

variable "file_uris" {
  type        = list
  default     = []
  description = "List of files to be downloaded."
}

variable "timestamp" {
  default     = ""
  description = "An integer, intended to trigger re-execution of the script when changed."
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the extension."
}

#### Variables for the container to store the script

variable "container_name" {
  default     = {}
  description = "The name of the container to store the scripts."
}

variable "stname" {
  default     = {}
  description = "Name of the storage account"
}

variable "script_name" {
  default     = {}
  description = "Name of the script to be uploaded"
}

variable "script_source" {
  default     = {}
  description = "Source script to be uploaded"
}

variable "storage_uri" {
	type    		= string
	description = "The Storage Account's Blob Endpoint from where to get the scripts"
}


