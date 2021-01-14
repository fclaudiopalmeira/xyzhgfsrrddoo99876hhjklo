module "rt" {
  source               = "../../modules/rt"
  location             = var.location
  Name                 = var.sqlmi_name
  resourceGroupName    = module.rgroup.name
  rules                = {
  
    routesJumpboxes = {
      name                = "routesJumpboxes"
      resource_group_name = module.rgroup.name
      route_table_name    = var.resourceGroupName
      address_prefix      = "65.55.188.0/24"
      next_hop_type       = var.hop_type
    }

  }
}
