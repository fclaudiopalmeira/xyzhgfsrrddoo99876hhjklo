resource "azurerm_databricks_workspace" "dw" {
  name                        = "${var.workspace}-workspace"
  resource_group_name         = var.resourceGroupName
  location                    = var.location
  sku                         = "standard"
  managed_resource_group_name = "${var.managedrgroup}-workspace-rg" ## Resource group where Azure should place the managed Databricks 
                                                                    ## resources. Changing this forces a new resource to be created. The name must be unique
                                                                    ## It is better if it is not the same resource group used for every other resource created
                                                                    ## by the code

  custom_parameters {
    no_public_ip        = false
    virtual_network_id  = var.virtual_network_id
    public_subnet_name  = var.public_delegation_subnet_name
    private_subnet_name = var.private_delegation_subnet_name
  }

  tags = var.common_azure_tags
}



