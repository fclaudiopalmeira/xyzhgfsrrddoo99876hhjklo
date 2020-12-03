# Storage account
resource "azurerm_storage_account" "asa-01" {
	name                        = var.Name
	resource_group_name         = var.resourceGroupName
	location                    = var.location
	account_replication_type    = var.replication #"LRS"
	account_tier                = var.tier #"Standard"
	allow_blob_public_access    = true
}