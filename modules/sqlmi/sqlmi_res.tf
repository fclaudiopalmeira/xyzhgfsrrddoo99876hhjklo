resource "azurerm_resource_group_template_deployment" "sqlmi" {
  name                = "dw_sql_managed_instance"
  resource_group_name = var.resourceGroupName
  deployment_mode     = "Complete"
  template_content    = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
      "managedInstanceTags": {
        "type": "object",
        "defaultValue": {
            "AppName": "${var.AppName}",
            "Environment": "${var.Environment}",
            "BillingIdentifier": "${var.BillingIdentifier}",
            "Description": "${var.Description}",
            "Organisation": "${var.Organisation}",
            "ResourceStateManagedBy": "Terraform and Arm Template"
        }
    }
  },
  "variables": {},
"resources": [
        {
            "type": "Microsoft.Sql/managedInstances",
            "sku": {
                "name": "${var.skuName}",
                "tier": "${var.skuEdition}"
            },
            "name": "${var.managedInstanceName}",
            "apiVersion": "2015-05-01-preview",
            "location": "${var.location}",
            "tags": "[parameters('managedInstanceTags')]",
            "identity": {
                "type": "SystemAssigned"
            },
            "properties": {
                "administratorLogin": "${var.administratorLogin}",
                "administratorLoginPassword": "${var.administratorLoginPassword}",
                "subnetId": "${var.subnetid}",
                "storageSizeInGB": "${var.storageSizeInGB}",
                "vCores": "${var.vCores}",
                "licenseType": "${var.licenseType}",
                "hardwareFamily": "${var.hardwareFamily}",
                "dnsZonePartner": "${var.dnsZonePartner}",
                "collation": "${var.collation}",
                "proxyOverride": "${var.proxyOverride}",
                "publicDataEndpointEnabled": "${var.publicDataEndpointEnabled}",
                "minimalTlsVersion": "${var.minimalTlsVersion}",
                "timezoneId": "${var.timezoneId}"
            }
        }
    ]
}
TEMPLATE

  // NOTE: Whilst there is an inline template here, it is recommended
  // sourcing this from a file for readability/editor support
  // unless the code is really short.
}


    