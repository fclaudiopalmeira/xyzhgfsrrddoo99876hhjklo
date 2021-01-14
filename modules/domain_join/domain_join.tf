resource "azurerm_virtual_machine_extension" "join_domain" {      
  name                 = "join-domain"
  virtual_machine_id   = var.res_vm_id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"  
  type_handler_version = "1.3"
  tags                 = var.common_azure_tags
  
  # NOTE: the `OUPath` field is set to blank as default, to put it in the Computers OU
  settings = <<SETTINGS
        {
            "Name": "${var.res_ad_domain}",
            "OUPath": "${var.res_active_directory_OUPath}",
            "User": "${var.res_ad_domain}\\${var.res_ad_domain_username}",
            "Restart": "true",
            "Options": "3"
        }
    SETTINGS

  protected_settings = <<SETTINGS
        {
            "Password": "${var.res_ad_domain_password}"
        }
    SETTINGS
}