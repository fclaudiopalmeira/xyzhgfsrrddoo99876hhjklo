output "databricks_workspace_resource_id" {
  // The ID of the Databricks Workspace in the Azure management plane.
  value = azurerm_databricks_workspace.dw.id
}

output "workspace_url" {
  // The workspace URL which is of the format 'adb-{workspaceId}.{random}.azuredatabricks.net'
  // this is not named as DATABRICKS_HOST, because it affect authentication
  value = "https://${azurerm_databricks_workspace.dw.workspace_url}/"
}