
variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "private_dns_zone_name" {
  description = "Private DNS Zone name."
  type        = string
}

variable "private_dns_zone_vnets_ids" {
  description = "IDs of the VNets to link to the Private DNS Zone."
  type        = list(string)
}

variable "tags" {
    type = map(any)  
  
}