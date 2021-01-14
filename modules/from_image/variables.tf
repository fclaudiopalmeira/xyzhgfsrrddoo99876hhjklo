variable "common_azure_tags" {
  type = map(string)
  description = "Common Azure tags to be applied to all created resources."
}

variable "license_type" {
  default     = null
  description = "SQL SERVER RESOURCE LICENSING."
}

variable "adminUsername" {
  default     = null
  description = "SQL SERVER RESOURCE LICENSING."
}

variable "adminPassword" {
  default     = null
  description = "SQL SERVER RESOURCE LICENSING."
}

variable "vmName" {
  default     = null
  description = "Name of the Virtual Machine."
}

variable "subnetplacement" {
  default     = null
  description = "Subnet where the vm will be placed."
}

variable "vmSize" {
  default     = null
  description = "Size of the Virtual Machine."
}
variable "disk_type" {
  default     = null
  description = "Type of the disk for the VM"
}

variable "disk_name" {
  default     = null
  description = "Name of the Disk to be used by the VM."
}

variable "image_id" {
  default     = null
  description = "ID of the Imageto be used on the VM creation"
}

variable "disk_size_gb" {
  default     = null
  description = "Size of the disk to be used by the VM in GB."
}

variable "pipName" {
  default     = null
  description = "Public IP Name."
}

variable "resourceGroupName" {
  default     = null
}

variable "location" {
  default     = null
}

variable "dnsLabelPrefix" {
  default     = null
  description = "Public IP Dns label."
}

variable "nicName" {
  default     = null
  description = "Public NIC name."
}

variable "subnet_id" {
  default     = null
}

