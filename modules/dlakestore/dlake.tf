resource "azurerm_storage_account" "moderndw" {
  name                     = "moderndwdev"
  resource_group_name      = var.resourceGroupName
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags = var.common_azure_tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "moderndw" {
  name               = "moderndwdev"
  storage_account_id = azurerm_storage_account.moderndw.id

  properties = {
    hello = "aGVsbG8="
  }
}