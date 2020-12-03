# Public IP
resource "azurerm_public_ip" "apip-01" {
	name                = var.pipName
	resource_group_name = var.resourceGroupName
	location            = var.location
	allocation_method   = "Dynamic"
	domain_name_label   = var.dnsLabelPrefix #  If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
}

# Network interface with IP configuration
resource "azurerm_network_interface" "anic-01" {
	depends_on=[azurerm_public_ip.apip-01]
	name                = var.nicName
	resource_group_name = var.resourceGroupName
	location            = var.location
	ip_configuration {
		name                            = "ipconfig1"
		private_ip_address_allocation   = "Dynamic"
		public_ip_address_id            = azurerm_public_ip.apip-01.id
    subnet_id                       = join(",",keys({for subnet in var.subnet_id: subnet.id => subnet                                   
                                           if subnet.name == "demosubnet-CDHB-DEV-2-APP"}))
	}
}
#### SUBNET_ID atribute setting explanation
#### The FOR expression filters the subnet by one specific ID, then the KEYS fucntion will return the ID
#### and the JOIN fucntion finishes the job by converting it to a string.

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "avm-01" {
  depends_on=[azurerm_network_interface.anic-01]  
  name                    = var.vmName
  resource_group_name     = var.resourceGroupName
  location                = var.location
  size                    = var.vmSize
  network_interface_ids   = [azurerm_network_interface.anic-01.id]
  computer_name           = var.vmName
  admin_username          = var.adminUsername
  admin_password          = var.adminPassword
  #custom_data             = base64encode("../../../modules/base_vm_windows/files/winrm.ps1") ### This will enable Winrm on The VM, thus enabling it to be configured using Ansible
  
  os_disk {
    name = var.osDiskName
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }  
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.windowsOSVersion
    version   = "latest"
  }  
  
  enable_automatic_updates = true
  provision_vm_agent       = true
  
  boot_diagnostics {
		storage_account_uri = var.storage_uri
	}
/*   tags = {
    application = var.app_name
    environment = var.environment 
  } */
}




## Output
# Host FQDN
output "hostname" {
	value   = azurerm_public_ip.apip-01.fqdn
}
