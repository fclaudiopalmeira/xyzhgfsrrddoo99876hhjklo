# Public IP
/* resource "azurerm_public_ip" "apip-01" {
	name                = var.pipName
	resource_group_name = var.resourceGroupName
	location            = var.location
	allocation_method   = "Dynamic"
	domain_name_label   = var.dnsLabelPrefix #  If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.
}
 */
# Network interface with IP configuration
resource "azurerm_network_interface" "anic-01" {
	#depends_on=[azurerm_public_ip.apip-01]
	name                = var.nicName
	resource_group_name = var.resourceGroupName
	location            = var.location
	ip_configuration {
		name                            = "ipconfig1"
		private_ip_address_allocation   = "Dynamic"
		#public_ip_address_id            = azurerm_public_ip.apip-01.id
    /* subnet_id                       = join(",",keys({for subnet in var.subnet_id: subnet.id => subnet                                   
                                           if subnet.name == "databricks-CDHB-SANDBOX-2-APP"})) */ ## -> Use this if a specific Subnet is required
    subnet_id                       = join(",",keys({for subnet in var.subnet_id: subnet.id => subnet                                   
                                           if subnet.name == var.subnetplacement}))
	}
}
#### SUBNET_ID atribute setting explanation
#### The FOR expression filters the subnet by one specific ID, then the KEYS fucntion will return the ID
#### and the JOIN fucntion finishes the job by converting it to a string.

locals {
  custom_data = <<CUSTOM_DATA
New-Item -Path "C:\" -Name "Applications\Scoop" -ItemType "directory"
$env:SCOOP='C:\Applications\Scoop\'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'Machine')
$env:SCOOP_GLOBAL=$env:ProgramData
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
## Adds scoop to the path in environment variables
$path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$newpath = $path + ';C:\Applications\Scoop\shims'
[Environment]::SetEnvironmentVariable("Path", $newpath, 'Machine')
## End of the Environment variables part

scoop install python
CUSTOM_DATA
}

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
  #custom_data             = base64encode("${file("../../scripts/${var.script_name}")}") ### This will run custom data in the VM, e.g. enable Winrm on The VM, thus enabling it to be configured using Ansible
  custom_data             = base64encode(local.custom_data)
  
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
  tags = var.common_azure_tags

}

## Output
# Host FQDN
/* output "hostname" {
	value   = azurerm_public_ip.apip-01.fqdn
}
 */