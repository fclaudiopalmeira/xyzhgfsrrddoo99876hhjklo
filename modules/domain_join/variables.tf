variable "res_vm_id" {
  type = string
  #type        = list(string)
  description = "The built virtual machine id"
}

variable "res_ad_domain" {
  type        = string
  description = "The Active directory domain name to join"
}

variable "res_ad_domain_username" {
  type        = string
  description = "The Active directory domain username to join"
}

variable "res_ad_domain_password" {
  type        = string
  description = "The Active directory domain password to join"
}

variable "res_active_directory_OUPath" {
  type        = string
  description = "The Active directory Origanisation Unit path of the domain to join"
}
variable "common_azure_tags" {
  type = map(string)
  description = "Common Azure tags to be applied to all created resources."
}