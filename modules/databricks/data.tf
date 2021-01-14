data "azurerm_storage_account_blob_container_sas" "example" {
 # connection_string = azurerm_storage_account.v2.primary_connection_string
  #container_name    = azurerm_storage_container.wasbs.name
  https_only        = true
  start = "2020-02-01"
  expiry = "2099-12-31"
  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}