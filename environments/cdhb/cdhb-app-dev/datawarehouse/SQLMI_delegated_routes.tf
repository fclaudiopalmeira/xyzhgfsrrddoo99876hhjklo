 ### ROUTE TABLES FOR USE ON THE DELEGATED SUBNETS
 module "rt" {
  source                   = "../../../../modules/rt"
  location                 = var.location
  managedInstanceName      = var.managedInstanceName
  common_azure_tags        = var.common_azure_tags
  resourceGroupName        = module.rgroup.name
  subnetid                 = join(",",keys({for subnet in module.subnet_delegated.subnet_delegated_id: subnet.id => subnet if subnet.name == "databricks-CDHB-DEV-2-SQLMI"}))
  routes                   = {
  
    routesJumpboxes = {
      name                 = "routesJumpboxes"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.managedInstanceName}"
      address_prefix       = "0.0.0.0/0"
      next_hop_type        = "${var.hop_type}"
    }
  }
}

/* 
    routesSAW_1 = {
      name                 = "SqlManagement_supportability_1"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.managedInstanceName}"
      address_prefix       = "0.0.0.0/0"
      next_hop_type        = "${var.hop_type}"
    }

    routesSAW_2 = {
      name                 = "SqlManagement_supportability_2"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.managedInstanceName}"
      address_prefix       = "0.0.0.0/0"
      next_hop_type        = "${var.hop_type}"
    }

    routesSAW_3 = {
      name                 = "SqlManagement_supportability_3"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.managedInstanceName}"
      address_prefix       = "0.0.0.0/0"
      next_hop_type        = "${var.hop_type}"
    }

    routesSAW_4 = {
      name                 = "SqlManagement_supportability_4"
      resource_group_name  = "${module.rgroup.name}"
      route_table_name     = "rt-${var.managedInstanceName}"
      address_prefix       = "0.0.0.0/0"
      next_hop_type        = "${var.hop_type}"
    }
 */