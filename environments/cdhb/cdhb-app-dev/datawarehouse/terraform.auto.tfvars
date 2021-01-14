## Common Variables
location              = "Australia East" ## This defines the Location of the Infrastructure
Name                  = "cdhb-DW-DEV-Vnet"
resourceGroupName     = "cdhb-DW-DEV-RG" ## This degines the Name of the Resource group

 
subnetNameDelegated  = {  
                    "databricks-CDHB-DEV-2-SQLMI"   = {
                                          	"address_prefixes"        = "10.102.36.0/25"
                                            "service_delegation_name" = "msSqlMi"                                            
                      }

}

#### To be readdded to the delegation variable
/*                  "databricks-CDHB-DEV-6-PRIVATE" = {                             
                                         	  "address_prefixes"        = "10.102.34.0/23"
                                            "service_delegation_name" = "dbkWorkspaces"

                      }
                      "databricks-CDHB-DEV-1-PUBLIC" ={
                                            "address_prefixes"        =  "10.102.32.0/23"  
                                            "service_delegation_name" = "dbkWorkspaces"  
                      } */


subnetServiceDelegatedName = {
                        "api" 					      = "Microsoft.ApiManagement/service"
                        "cosmos" 				      = "Microsoft.AzureCosmosDB/clusters"
                        "bareMetalVM" 			  = "Microsoft.BareMetal/AzureVMware"
                        "bareMetalCray" 		  = "Microsoft.BareMetal/CrayServers"
                        "batchAcc" 			      = "Microsoft.Batch/batchAccounts"
                        "containerGrp" 		    = "Microsoft.ContainerInstance/containerGroups"
                        "dbkWorkspaces" 		  = "Microsoft.Databricks/workspaces"
                        "mySQLFlex" 			    = "Microsoft.DBforMySQL/flexibleServers"
                        "mySQLSv2" 			      = "Microsoft.DBforMySQL/serversv2"
                        "postgreSQLFlex" 		  = "Microsoft.DBforPostgreSQL/flexibleServers"
                        "postgreSQLSv2" 		  = "Microsoft.DBforPostgreSQL/serversv2"
                        "postgreSQLSingle" 	  = "Microsoft.DBforPostgreSQL/singleServers"
                        "dedicatedHSMs" 		  = "Microsoft.HardwareSecurityModules/dedicatedHSMs"
                        "kustoClusters" 		  = "Microsoft.Kusto/clusters"
                        "logicApp" 			      = "Microsoft.Logic/integrationServiceEnvironments"
                        "mlWorkspaces" 		    = "Microsoft.MachineLearningServices/workspaces"
                        "netappVol"			      = "Microsoft.Netapp/volumes"
                        "managedResolvers"	  = "Microsoft.Network/managedResolvers"
                        "vnetaccesslinks" 		= "Microsoft.PowerPlatform/vnetaccesslinks"
                        "fabricMesh" 			    = "Microsoft.ServiceFabricMesh/networks"
                        "msSqlMi" 				    = "Microsoft.Sql/managedInstances"
                        "msSqlServer" 			  = "Microsoft.Sql/servers"
                        "streamAnalyticsJobs"	= "Microsoft.StreamAnalytics/streamingJobs"
                        "synapseWorkspaces" 	= "Microsoft.Synapse/workspaces"
                        "webHostEnv" 			    = "Microsoft.Web/hostingEnvironments"
                        "webServerFarms" 		  = "Microsoft.Web/serverFarms"
}

#[ "databricks-CDHB-DEV-2-SQLMI", "databricks-CDHB-DEV-6-PRIVATE"]  ## TODO This must be  a list 
### The Managed Instance subnet is created by the SQLMI module, because it is delegated to the instance
subnetPrefix          = {
                        "databricks-CDHB-DEV-3-APPLICATIONS"        = "10.102.38.0/25"
                        "databricks-CDHB-DEV-4-DATA-PLATFORM"       = "10.102.36.128/25"
                        "databricks-CDHB-DEV-5-DATA-GATEWAY"        = "10.102.37.0/25"                   
}

common_azure_tags = {
  Organisation             = "cdhb"
  Environment              = "dev"
  BillingIdentifier        = "6400932"
  AppName                  = "ModernDW"
  Description              = "Decision Support Modern Data Warehouse"
  ResourceStateManagedBy   = "Terraform"
}

## Vm Variables
vmName                = "cdhb-DW-DEV-vm"
osDiskName            = "cdhb-DW-DEV-disk"
adminUsername         = "theadmin" ## This defines the Username to login on the VM
adminPassword         = "xfg@@#3456hhJ" ## This defines the password to login on the VM
dnsLabelPrefix        = "cdhb-DW-DEV"
nicName               = "cdhb-DW-DEV-Nic"
pipName               = "cdhb-DW-DEV-PublicIp"
vmSize                = "Standard_D2_v3"
disk_size_gb          = 1023
## Storage Account Variables
replication           = "LRS" ## Possible values are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS, currently LRS is set as the default
tier                  = "Standard" ## Possible values are Standard and Premium, currently Standard is set as the default

## Application variables
ansible               = "yes"
storage_account_type  = "Standard_LRS" ## The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS.

### SQL MANAGD INSTANCES

#sqlmi_name            = null
managedInstanceName   = "c-ae-d-dw-sqlmi"
hop_type              = "internet"


## Domain Join
## should be reading from secure key vault, the architects office may plan to create one for the DW suscription (TBC)
res_ad_domain               = "cdhb.local" ## "healthhub.health.nz" ##secure key vault
res_ad_domain_username      = "srv-azdomainjoin" ## "azuredomainjoin" ##secure key vault
res_ad_domain_password      = "Moz*2Flp2sx% )v8b8uRmYdTv" ## "Temp123456!!!!" ##secure key vault
res_active_directory_OUPath = "OU=Sophos on-access scanning enabled,OU=Servers,DC=cdhb,DC=local"


## VNet Peering ### SDW-DEV <-> PCS-NPD (cdhb-DW-DEV-Vnet <-> c-ae-n-pcs-vnet)
remote_vnet_name           = "c-ae-n-pcs-vnet"
remote_resource_group_name = "c-ae-n-pcs-vnet-rg" 
remote_vnet_id             = "/subscriptions/d0773ef0-9668-4c8b-be56-ca3cba530fb3/resourceGroups/c-ae-n-pcs-vnet-rg/providers/Microsoft.Network/virtualNetworks/c-ae-n-pcs-vnet"