## This Block outputs the name of the Resource Group
output "uri" {
  value = "${azurerm_storage_account.asa-01.primary_blob_endpoint}"
}

## Name of the Storage account to be exported
output "stname" {
  value = "${azurerm_storage_account.asa-01.name}"
}

### URL TO ACCESS THE FILE
output "url" {
  value = "${azurerm_storage_account.asa-01.primary_file_endpoint}"
}