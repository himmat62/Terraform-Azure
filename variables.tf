variable "tags" {
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default = {
    "CostCenter"   = "PRJ_12234"
    "Environemnt"  = "Prod"
    "ProjectName"  = "London ALZ Setup"
    "ProjectOwner" = "HimmatSingh"
    "SPOC"         = "HIMMATBA"
    "deployedBy"   = "terraform"
    "description"  = "hub-for-transit-gateway"
    "resource"     = "resource-group"
  }

}

variable "existing_ddos_protection_plan_resource_id" {
  type        = string
  description = "If specified, module will skip creation of DDoS Protection Plan and use existing."
  default     = ""
}

variable "hub_sub_id" {
  default = "06b9deda-e935-46b7-b34f-51d4946229ee"
  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.hub_sub_id)) || var.hub_sub_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }

}
variable "management_sub_id" {
  default = "f16549f0-c47f-4c78-94f3-f005e2ff26a7"
  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.management_sub_id)) || var.management_sub_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }

}
variable "rsf_sub_id" {
  default = "6b350204-f4f4-4e94-add6-5a1aa8a16e6c"
  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.rsf_sub_id)) || var.rsf_sub_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }

}
variable "identity_sub_id" {
  default = "be53d3d4-8449-4119-b619-a9d343613474"
  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.identity_sub_id)) || var.identity_sub_id == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }

}
variable "location" {
  type        = string
  description = "Sets the default location used for resource deployments where needed."
  default     = "uksouth"

}

variable "resource_group_names_by_scope" {
  type        = any
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default     = {}
}

variable "resource_group_names_management" {
  type        = map(any)
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default     = {}

}
variable "resource_group_names_identity" {
  type        = map(any)
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default     = {}
}
variable "resource_group_names_hub" {
  type        = map(any)
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default     = {}
}
variable "resource_group_names_rsf" {
  type        = map(any)
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default = {

  }
}

variable "custom_settings_by_resource_type" {
  type        = any
  description = "If specified, allows full customization of common settings for all resources (by type) deployed by this module."
  default = {
  }
}

variable "configure_hub_networking_resources" {
  type = object({
    settings = optional(object({
      hub_networks = optional(list(
        object({
          enabled = optional(bool, true)
          config = object({
            address_space                = list(string)
            name                         = string
            resource_group_name          = string
            description                  = string
            location                     = optional(string, "")
            link_to_ddos_protection_plan = optional(bool, false)
            dns_servers                  = optional(list(string), [])
            bgp_community                = optional(string, "")
            subnets = optional(list(
              object({
                name                      = string
                address_prefixes          = list(string)
                network_security_group_id = optional(string, "")
                route_table_id            = optional(string, "")
              })
            ), [])
            virtual_network_gateway = optional(object({
              enabled = optional(bool, false)
              config = optional(object({
                name                     = optional(string, "")
                public_ip_name           = optional(string, "")
                address_prefix           = optional(string, "")
                gateway_sku_expressroute = optional(string, "")
                gateway_sku_vpn          = optional(string, "")
                advanced_vpn_settings = optional(object({
                  enable_bgp                       = optional(bool, null)
                  active_active                    = optional(bool, null)
                  private_ip_address_allocation    = optional(string, "")
                  default_local_network_gateway_id = optional(string, "")
                  vpn_client_configuration = optional(list(
                    object({
                      address_space = list(string)
                      aad_tenant    = optional(string, null)
                      aad_audience  = optional(string, null)
                      aad_issuer    = optional(string, null)
                      root_certificate = optional(list(
                        object({
                          name             = string
                          public_cert_data = string
                        })
                      ), [])
                      revoked_certificate = optional(list(
                        object({
                          name             = string
                          public_cert_data = string
                        })
                      ), [])
                      radius_server_address = optional(string, null)
                      radius_server_secret  = optional(string, null)
                      vpn_client_protocols  = optional(list(string), null)
                      vpn_auth_types        = optional(list(string), null)
                    })
                  ), [])
                  bgp_settings = optional(list(
                    object({
                      asn         = optional(number, null)
                      peer_weight = optional(number, null)
                      peering_addresses = optional(list(
                        object({
                          ip_configuration_name = optional(string, null)
                          apipa_addresses       = optional(list(string), null)
                        })
                      ), [])
                    })
                  ), [])
                  custom_route = optional(list(
                    object({
                      address_prefixes = optional(list(string), [])
                    })
                  ), [])
                }), {})
              }), {})
            }), {})
          })
        })
      ))
      })
    )
  })

  default = {
    settings = {
      # Create two hub networks 
      # and link to DDoS protection plan if created
      hub_networks = [
        { enabled = true
          config = {
            address_space                   = ["10.100.0.0/22", ]
            location                        = "uksouth"
            dns_servers                     = [""]
            name                            = "hub-1"
            description                     = "hub-1"
            enable_hub_network_mesh_peering = true
            resource_group_name             = "hub"
            link_to_ddos_protection_plan    = false
            subnets = [
              {
                name             = "rsf-subnet"
                address_prefixes = ["10.100.1.0/24"]

              }
            ]
            virtual_network_gateway = {
              enabled = true
              config = {
                name            = "vpngw"
                gateway_sku_vpn = "VpnGw3AZ"
                public_ip_name  = "pub-ip"
                address_prefix  = "10.100.4.0/24"
                advanced_vpn_settings = {
                  private_ip_address_allocation = "Dynamic"
                  enable_bgp                    = true
                  active_active                 = true
                }
                vpn_client_configuration = [
                  {
                    address_space = ["10.100.4.4/24"]

                  }
                ]
                bgp_settings = [
                  {}
                ]
                custom_route = [
                  {}
                ]

              }
            }
          }
        }
        ,
        {
          enabled = true
          config = {
            address_space                   = ["10.101.0.0/22", ]
            location                        = "uksouth"
            name                            = "hub-2"
            description                     = "hub-2"
            dns_servers                     = [""]
            enable_hub_network_mesh_peering = true
            resource_group_name             = "hub"
            link_to_ddos_protection_plan    = false
            subnets                         = []
          }
        }

      ]
    }
  }
}
