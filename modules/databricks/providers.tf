provider "azurerm" {
  version = "~> 2.14"
  features {}
}

provider "random" {
  version = "~> 2.2"
}

provider "databricks" {
  azure_workspace_resource_id = var.databricks_workspace_resource_id
}

