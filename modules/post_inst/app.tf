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
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy unrestricted -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/${var.script_name}; c:/azuredata/${var.script_name}\""
    }
  SETTINGS
  tags                       = var.tags
}



/* 
resource "azurerm_virtual_machine_extension" "ansible" {
  name                       = "${var.virtual_machine_name}-run-command"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  settings = <<SETTINGS
    {
        "commandToExecute": "$PROFILE.AllUsersCurrentHost | powershell -ExecutionPolicy unrestricted -NonInteractive -command \"cp c:/azuredata/customdata.bin c:/azuredata/${var.script_name}; c:/azuredata/${var.script_name}\""
    }
  SETTINGS
  tags                       = var.tags
} */