# Create container in storage acc and container for use by blob mount tests
/* resource "azurerm_storage_account" "blobaccount" {
  name                     = "${local.prefix}blob"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags = var.common_azure_tags
} */

resource "azurerm_storage_container" "dw" {
  name                  = "sample" # example name: "${local.prefix}-wasbs"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}



resource "databricks_azure_blob_mount" "dw" {
  container_name       = azurerm_storage_container.dw.name
  storage_account_name = var.storage_account_name
  mount_name           = "dw"
  auth_type            = "ACCESS_KEY"
  token_secret_scope   = databricks_secret_scope.dw.name
  token_secret_key     = databricks_secret.storage_key.key
}