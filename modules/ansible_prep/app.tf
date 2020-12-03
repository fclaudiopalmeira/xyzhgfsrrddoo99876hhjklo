### Uploads the Script to the blob storage and the retrieve it inside the Windows VM to use it

  resource "azurerm_storage_container" "scripts" {
    name                  = var.container_name
    storage_account_name  = var.stname
    container_access_type = "blob"
    #container_access_type = "private"
  }
  
  resource "azurerm_storage_blob" "script_ps1" {
    name = var.script_name
    storage_account_name   = var.stname
    storage_container_name = azurerm_storage_container.scripts.name
    type                   = "Block"
    source                 = var.script_source ## "ps.ps1"
  }

resource "azurerm_virtual_machine_extension" "ansible" {
  name                       = "${var.virtual_machine_name}-run-command"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -file ./${var.script_name}"
    }
  PROTECTED_SETTINGS
  settings = <<SETTINGS
    {
      "fileUris": ["${var.storage_uri}scripts/${var.script_name}"]
    }
  SETTINGS
  tags                       = var.tags
}