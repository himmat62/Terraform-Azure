variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet in which the Private Endpoint will be created."
  type        = string
}

variable "subresource_name" {
  description = "Name of the subresource corresponding to the target Azure resource. Only valid if `target_resource` is not a Private Link Service."
  type        = string
  default     = ""
}

variable "is_manual_connection" {
  description = "Does the Private Endpoint require manual approval from the remote resource owner? Default to `false`."
  type        = bool
  default     = false
}

variable "private_dns_zones_ids" {
  description = "IDs of the Private DNS Zones in which a new record will be created for the Private Endpoint. Only valid if `use_existing_private_dns_zones` is set to `true` and `target_resource` is not a Private Link Service. One of `private_dns_zones_ids` or `private_dns_zones_names` must be specified."
  type        = list(string)
  default     = []
}

variable "private_dns_zones_names" {
  description = "Names of the Private DNS Zones to create. Only valid if `use_existing_private_dns_zones` is set to `false` and `target_resource` is not a Private Link Service. One of `private_dns_zones_ids` or `private_dns_zones_names` must be specified."
  type        = list(string)
  default     = []
}

variable "private_endpoint_name" {
  type        = string
  description = "Private Endpoint name"
  default     = "test-endpoint"
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "Private DNS Zone Group name"
  default     = "test-dns-zone-group"
}

variable "private_service_connection_name" {
  type        = string
  description = "Custom Private Service Connection name"
  default     = "test-privateserviceconnection"
}

