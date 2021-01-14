/* locals {
  custom_data_params  = "Param($ComputerName = \"${var.vmName}\")"
  custom_data_content = "${local.custom_data_params} ${file(format("%s/files/winrm.ps1", path.module))}"
}
 */

 locals {
   custom_data_content = "${file(format("%s/files/winrm.ps1", path.module))}"
}
