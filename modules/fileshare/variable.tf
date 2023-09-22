variable "create_resource_group" {
  description = "Boolean flag which controls if new resource group needs to be created"
  default     = false
  type        = bool
}

variable "resource_group_name" {
  description = "A logical group that holds related resources for an Azure solution"
  default     = "rg-fileshare-01"
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources"
  default     = "uksouth"
  type        = string
}


variable "storage_account_name" { #can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
  description = "The name of the azure storage account"
  default     = "alzstorage"
  type        = string
}

variable "account_kind" {
  description = "The type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2"
  default     = "FileStorage"
  type        = string
}

variable "skuname" {
  description = "The SKUs supported by Microsoft Azure Storage. Valid options are Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS"
  default     = "Standard_RAGRS"
  type        = string
}

variable "access_tier" {
  description = "Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`."
  default     = "Hot"
  type        = string
}

variable "enable_https_traffic_only" {
  description = "Whether to enable https traffic only"
  default     = true
  type        = bool
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account, possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_2"
  default     = "TLS1_2"
  type        = string
}

variable "enable_protocal" {
  description = "Protocal to be enabled SMB or NFS"
  type        = string
  default     = "SMB"
}

variable "large_file_share_enabled" {
  description = "Protocal to be enabled SMB or NFS"
  type        = bool
  default     = true
}

variable "multichannel_enabled" {
  description = "applicable for only premium storage account"
  type        = bool
  default     = false
}

variable "cross_tenant_replication_enabled" {
  description = "Boolean flag which controls if cross tenant replication is enabled."
  default     = true
  type        = bool
}

variable "public_network_access_enabled" { ## Chanllage here after public access disable it now allowed to enable again 
  description = "Boolean flag which controls if public Network access should be enabled."
  default     = true
  type        = bool
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the Storage Account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD)."
  type        = bool
  default     = true
}

# Threat Protection 

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if files are larger than 5120GB (5TB) then it should be true"
  default     = false
  type        = bool
}

## Storage Firewall 

variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type = object({
    default_action             = optional(string, "Deny")                                        ## Deny or Allow
    bypass                     = optional(list(string), ["AzureServices", "Logging", "Metrics"]) ## traffic bypass for Logging/Metrics/AzureServices or None
    ip_rules                   = optional(list(string), [])                                      ## only list of Public Ip's or IP ranges in CIDR formatand  are only IPv4 31 or /32 and Private IP ranges not allowed
    virtual_network_subnet_ids = optional(list(string), [])                                      ## List of Snet ids to secure storage account
  })
  default = {}
}

## FileShare configuration 

variable "file_share_retention_policy_in_days" {
  description = "Storage Account file shares retention policy in days. Enabling this may require additional directory permissions. Default 7 days, it should be between 1 and 365 days"
  type        = number
  default     = null
}

variable "file_shares" {
  description = "list of fileshare and thier quota and protocal"
  type = list(object({
    name             = string
    quota_in_gb      = number
    enabled_protocol = optional(string)
    metadata         = optional(map(string))
    acl = optional(list(object({
      id          = string
      permissions = string
      start       = optional(string)
      expiry      = optional(string)
    })))
  }))
  default = []
}

variable "file_share_properties_smb" {
  description = "Storage Account file shares smb properties. Possible values are as per comment for each type"
  type = object({
    versions                        = optional(list(string), null) ## SMB2.1, SMB3.0 and SMB3.1.1
    authentication_types            = optional(list(string), null) ## NTLMv2 and Kerberos
    kerberos_ticket_encryption_type = optional(list(string), null) ## RC4-HMAC and AES-256
    channel_encryption_type         = optional(list(string), null) ## AES-128-CCM , AES-128-GCM and AES-256-GCM 
    multichannel_enabled            = optional(bool, null)         ## only support Premium Storage Account 
  })
  default = null
}

variable "file_share_cors_rules" {
  description = "Storage Account file shares CORS rule."
  type = object({
    allowed_headers    = list(string) ## A list of headers that are allowed to be a part of the cross-origin request.
    allowed_methods    = list(string) ## A list of HTTP methods that are allowed to be executed by the origin. Valid options are DELETE, GET, HEAD, MERGE, POST, OPTIONS, PUT or PATCH.
    allowed_origins    = list(string) ## A list of origin domains that will be allowed by CORS
    exposed_headers    = list(string) ## A list of response headers that are exposed to CORS clients.
    max_age_in_seconds = number       ## The number of seconds the client should cache a preflight response.
  })
  default = null
}

## Private DNS Zone for storage

variable "create_private_dns_zone" {
  description = "Boolean flag which controls if private DNS should be created."
  default     = true
  type        = bool
}


variable "private_dns_zone_name" {
  type    = string
  default = "privatelink.file.core.windows.net"

}

variable "fileshare_resource_group" {
  type    = string
  default = "example-resources"

}

variable "fileshare_vnet_name" {
  type    = string
  default = "example-network"

}

variable "fileshare_subnet_name" {
  type    = string
  default = "endpoint_subnet"
}

variable "subresource_names" {
  type    = list(string)
  default = ["file"]
}

#Identity 

variable "managed_identity_type" {
  description = "The type of Managed Identity which should be assigned . Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
  default     = null
  type        = string
}

variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to storage account"
  default     = null
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}