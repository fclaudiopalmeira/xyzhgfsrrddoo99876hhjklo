# Public IP --- NEEDS TO BE REMOVED BEFORE GOING TO DEV
/* resource "azurerm_public_ip" "apip-02" {
	name                = var.pipName
	resource_group_name = var.resourceGroupName
	location            = var.location
	allocation_method   = "Dynamic"
	domain_name_label   = var.dnsLabelPrefix #  If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
    tags = var.common_azure_tags
}
 */
# Network interface with IP configuration
resource "azurerm_network_interface" "anic-02" {
	#depends_on=[azurerm_public_ip.apip-02]
	name                = var.nicName
	resource_group_name = var.resourceGroupName
	location            = var.location
	ip_configuration {
		name                            = "ipconfig1"
		private_ip_address_allocation   = "Dynamic"
		#public_ip_address_id            = azurerm_public_ip.apip-02.id
    subnet_id                       = join(",",keys({for subnet in var.subnet_id: subnet.id => subnet                                   
                                           if subnet.name == var.subnetplacement}))
	}
    tags = var.common_azure_tags
}

# Create a new Virtual Machine based on the Golden Image From the Shared Galleries
resource "azurerm_virtual_machine" "image" {
  name                             = var.vmName
  location                         = var.location
  resource_group_name              = var.resourceGroupName
  network_interface_ids            = [azurerm_network_interface.anic-02.id]
  vm_size                          = var.vmSize
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  license_type          = "Windows_Server"

  storage_image_reference {    
    id = var.image_id
  }

  storage_os_disk {
    name              = "OS-${var.disk_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
    disk_size_gb      = var.disk_size_gb
  }

  storage_data_disk {
    name              = "DATA1-${var.disk_name}"
    managed_disk_type = var.disk_type
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = var.disk_size_gb
  }

  storage_data_disk {
    name              = "DATA2-${var.disk_name}"
    managed_disk_type = var.disk_type
    create_option     = "Empty"
    lun               = 1
    disk_size_gb      = var.disk_size_gb
  }

  os_profile {
    computer_name  = var.vmName
    admin_username = var.adminUsername
    admin_password = var.adminPassword
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
    timezone                  = "New Zealand Standard Time"
  }

  tags = var.common_azure_tags
}

resource "azurerm_mssql_virtual_machine" "sqllicensing" {
  virtual_machine_id = azurerm_virtual_machine.image.id
  sql_license_type   = var.license_type  
  tags = var.common_azure_tags
}