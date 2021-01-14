variable "skuName" {
description = "The name of the SKU, typically, a letter + Number code"
}

variable "skuEdition" {
description = "The tier or edition of the particular SKU, e.g. Basic, Premium."
    
}

variable "managedInstanceName" {
description = "The Name of the instance"
    
}

variable "location" {
description = "The Zone location of the instance"    
}

variable "administratorLogin" {
description = "Login of the Instance"    
}

variable "administratorLoginPassword" {
description = "The password for the instance"    
}

variable "resourceGroupName" {
description = "Resource Group name"    
}

variable "virtualNetworkName" {
description = "Vnet Name"
    
}

variable "subnetid" {
description = "Subnet ID"
    
}

variable "storageSizeInGB" {
description = "The storage size for the Instance"
    
}

variable "vCores" {
description = "Number of Cpu Cores for the Instance"
    
}

variable "licenseType" {
description = "The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses)."

}

variable "hardwareFamily" {
description = "Hardware genreation for the Instance"
}

variable "dnsZonePartner" {
description = "The resource id of another managed instance whose DNS zone this managed instance will share after creation."
    
}

variable "collation" {
description = "Database Collation"
}

variable "proxyOverride" {
description = "Hardware genreation for the Instance"    
}

variable "publicDataEndpointEnabled" {
description = "Whether or not the public data endpoint is enabled."     
}

variable "minimalTlsVersion" {
description = "Minimal TLS version. Allowed values: 'None', '1.0', '1.1', '1.2'"
}

variable "timezoneId" {
description = "Id of the timezone. Allowed values are timezones supported by Windows."
}

#### TAGGING SETION

  variable "AppName" {
  description = "Application Name"
  }
  variable "Environment" {
  description = "Environment where the application will is deployed"
  }
  variable "BillingIdentifier" {
  description = "Identifier of the depertment being billed"

  }
  variable "Description" {
  description = "Application Description"

  }
  variable "Organisation" {
  description = "Organisation using the application"

  }
  