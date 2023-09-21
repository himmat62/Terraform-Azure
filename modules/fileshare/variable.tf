variable "create_resource_group" {
<<<<<<< HEAD
  description = "Whether to create resource group"
=======
  description = "Boolean flag which controls if new resource group needs to be created"
>>>>>>> 6b07966 (adding gitignore)
  default     = false
  type        = bool
}

variable "resource_group_name" {
<<<<<<< HEAD
  description = "A container that holds related resources for an Azure solution"
=======
  description = "A logical group that holds related resources for an Azure solution"
>>>>>>> 6b07966 (adding gitignore)
  default     = "rg-fileshare-01"
  type        = string
}

variable "location" {
<<<<<<< HEAD
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
=======
  description = "The location/region to keep all your network resources"
>>>>>>> 6b07966 (adding gitignore)
  default     = "uksouth"
  type        = string
}


variable "storage_account_name" { #can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
  description = "The name of the azure storage account"
  default     = "alzstorage"
  type        = string
}

variable "account_kind" {
  description = "The type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  default     = "FileStorage"
  type        = string
}

variable "skuname" {
  description = "The SKUs supported by Microsoft Azure Storage. Valid options are Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS"
  default     = "Standard_RAGRS"
  type        = string
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool."
  default     = "Hot"
  type        = string
}

variable "enable_https_traffic_only" {
  description = "Whether to enable https traffic only"
  default     = true
  type        = bool
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"
  type        = string
}
<<<<<<< HEAD
=======

>>>>>>> 6b07966 (adding gitignore)
variable "enable_protocal" {
  description = "Protocal to be enabled SMB or NFS"
  type        = string
  default     = "SMB"
}

<<<<<<< HEAD
variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  default     = false
=======
variable "large_file_share_enabled" {
  description = "Protocal to be enabled SMB or NFS"
  type        = bool
  default     = false
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if files are larger than 5120GB (5TB) then it should be true"
  default     = false
  type        = bool
}

variable "cross_tenant_replication_enabled" {
  description = "Boolean flag which controls if cross tenant replication is enabled."
  default     = true
>>>>>>> 6b07966 (adding gitignore)
  type        = bool
}

variable "public_network_access_enabled" { ## Chanllage here after public access disable it now allowed to enable again 
  description = "Boolean flag which controls if public Network access should be enabled."
  default     = true
  type        = bool
}

variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type = object({
<<<<<<< HEAD
    default_action = optional(string, "Deny")  #Deny or Allow
    bypass     = optional(list(string), ["AzureServices", "Logging", "Metrics"])  #traffic bypass for Logging/Metrics/AzureServices or None
    ip_rules   = optional(list(string), []) #only list of Public Ip's are allowd
    virtual_network_subnet_ids = optional(list(string), []) #List of Snet ids to secure storage account
=======
    default_action             = optional(string, "Deny")                                        #Deny or Allow
    bypass                     = optional(list(string), ["AzureServices", "Logging", "Metrics"]) #traffic bypass for Logging/Metrics/AzureServices or None
    ip_rules                   = optional(list(string), [])                                      #only list of Public Ip's are allowd
    virtual_network_subnet_ids = optional(list(string), [])                                      #List of Snet ids to secure storage account
>>>>>>> 6b07966 (adding gitignore)
  })
  default = {}
}

variable "file_shares" {
  description = "list of fileshare and thier quota"
  type = list(object({
    name = string, quota = number
  }))
  default = [
    #{name = "test", quota = 100},
    #{name = "test1", quota = 5}
  ]
}

<<<<<<< HEAD
=======
## Private DNS Zone storage

variable "create_private_dns_zone" {  
  description = "Boolean flag which controls if private DNS should be created."
  default     = true
  type        = bool
}


variable "private_dns_zone_name" {
  type = string
  default = "privatelink.file.core.windows.net"
  
}

variable "fileshare_resource_group" {
  type = string
  default = "example-resources"
  
}

variable "fileshare_vnet_name" {
  type = string
  default = "example-network"
  
}

variable "fileshare_subnet_name" {
  type = string
  default = "endpoint_subnet"
}

variable "subresource_names" {
type = list(string)
default = [ "file" ]
} 

>>>>>>> 6b07966 (adding gitignore)
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
<<<<<<< HEAD
}
=======
}
>>>>>>> 6b07966 (adding gitignore)
