
resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

locals {
  // dltp - databricks labs terraform provider
  prefix   = "dltp${random_string.naming.result}"
  location = "eastus"
  cidr     = var.cidr
  // tags that are propagated down to all resources
  tags = var.common_azure_tags
}


