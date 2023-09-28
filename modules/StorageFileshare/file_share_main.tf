
data "http" "ip" { ##Get TF client Public IP for subsequest to lock down Storage account if default action is Deny
  url = "https://ifconfig.me/ip"
}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

data "azurerm_virtual_network" "fileshare-vnet" {
  name                = var.fileshare_vnet_name
  resource_group_name = var.fileshare_resource_group
}

data "azurerm_subnet" "fileshare_snet" {
  name                 = var.fileshare_subnet_name
  virtual_network_name = var.fileshare_vnet_name
  resource_group_name  = var.fileshare_resource_group
}

data "azurerm_resource_group" "rg-rsf" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg-new" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags)
}

resource "azurerm_storage_account" "fileshare_storage" {
  name                              = "${local.storage_account_name}${random_string.unique.result}"
  resource_group_name               = local.resource_group_name
  location                          = local.location
  account_kind                      = var.account_kind
  account_tier                      = local.account_tier #TransactionOptimized, Hot,Cool, Premium
  account_replication_type          = local.account_replication_type
  enable_https_traffic_only         = var.enable_https_traffic_only
  min_tls_version                   = var.min_tls_version
  public_network_access_enabled     = var.public_network_access_enabled
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  shared_access_key_enabled         = var.shared_access_key_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled


  dynamic "identity" {
    for_each = var.managed_identity_type != null ? [1] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }

  dynamic "share_properties" {
    for_each = local.cors_settings != null || var.file_share_retention_policy_in_days != null || var.file_share_properties_smb != null ? ["enabled"] : []
    content {
      dynamic "cors_rule" {
        for_each = local.cors_settings != null ? ["enabled"] : []
        content {
          allowed_headers    = local.cors_settings.allowed_headers
          allowed_methods    = local.cors_settings.allowed_methods
          allowed_origins    = local.cors_settings.allowed_origins
          exposed_headers    = local.cors_settings.exposed_headers
          max_age_in_seconds = local.cors_settings.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = var.file_share_retention_policy_in_days != null ? ["enabled"] : []
        content {
          days = var.file_share_retention_policy_in_days
        }
      }

      dynamic "smb" {
        for_each = local.smb_settings != null ? ["enabled"] : []
        content {
          authentication_types            = local.smb_settings.authentication_types
          channel_encryption_type         = local.smb_settings.channel_encryption_type
          kerberos_ticket_encryption_type = local.smb_settings.kerberos_ticket_encryption_type
          versions                        = local.smb_settings.versions
          multichannel_enabled            = local.smb_settings.multichannel_enabled
        }
      }

    }
  }

  dynamic "azure_files_authentication" {
    for_each = var.file_share_authentication != null ? ["enabled"] : []
    content {
      directory_type = var.file_share_authentication.directory_type
      dynamic "active_directory" {
        for_each = var.file_share_authentication.directory_type == "AD" ? [var.file_share_authentication.active_directory] : []
        iterator = ad
        content {
          storage_sid         = ad.value.storage_sid
          domain_name         = ad.value.domain_name
          domain_sid          = ad.value.domain_sid
          domain_guid         = ad.value.domain_guid
          forest_name         = ad.value.forest_name
          netbios_domain_name = ad.value.netbios_domain_name
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }

  tags = merge({ "ResourceName" = format("%s", local.resource_group_name) }, var.tags)


}

## Advance Threat protection Microsoft Defender enable 

resource "azurerm_advanced_threat_protection" "atp" {
  target_resource_id = azurerm_storage_account.fileshare_storage.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_storage_account_network_rules" "net_rules" {
  count                      = var.public_network_access_enabled == true ? 1 : 0
  storage_account_id         = azurerm_storage_account.fileshare_storage.id
  default_action             = var.network_rules.default_action
  bypass                     = var.network_rules.bypass
  ip_rules                   = var.network_rules.ip_rules
  virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids
  depends_on = [
    azurerm_storage_account.fileshare_storage
  ]
}


resource "azurerm_storage_share" "file_shares" {
  for_each = try({ for s in var.file_shares : s.name => s }, {})

  storage_account_name = azurerm_storage_account.fileshare_storage.name

  name  = each.key
  quota = each.value.quota_in_gb

  enabled_protocol = each.value.enabled_protocol
  metadata         = each.value.metadata

  dynamic "acl" {
    for_each = each.value.acl != null ? each.value.acl : []

    content {
      id = acl.value.id

      access_policy {
        permissions = acl.value.permissions
        start       = acl.value.start
        expiry      = acl.value.expiry
      }
    }
  }
  lifecycle {
    precondition {
      condition     = each.value.enabled_protocol == "NFS" ? local.account_tier == "Premium" : true
      error_message = "NFS file shares can only be enabled on Premium Storage Accounts.( To do --- **secure transfer should be disabled for NFS)"
    }
    precondition {
      condition     = local.account_tier != "Premium" || each.value.quota_in_gb >= 100
      error_message = "File share quota must be at least 100Gb for Premium Storage Accounts."
    }
  }

  depends_on = [
    azurerm_storage_account.fileshare_storage
  ]

}

/**  TO DO ..

resource "azurerm_storage_share_directory" "mynewfileshare" {
  for_each             = { for u in var.file_shares : u.name => u }
  name                 = "himmat"
  share_name           = azurerm_storage_share.file_shares[each.key].name
  storage_account_name = azurerm_storage_account.fileshare_storage.name
}
**/


### Private DNS Zone creation 

resource "azurerm_private_dns_zone" "private_dnszone" {
  count               = var.create_private_dns_zone == true ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  count                 = var.create_private_dns_zone == true ? 1 : 0
  name                  = "vnet_link_${local.storage_account_name}"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dnszone[count.index].name
  virtual_network_id    = data.azurerm_virtual_network.fileshare-vnet.id
}

resource "azurerm_private_endpoint" "endpoint" {
  count               = var.create_private_dns_zone == true ? 1 : 0
  name                = "pvtendpoint-${local.storage_account_name}"
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = data.azurerm_subnet.fileshare_snet.id


  private_service_connection {
    name                           = "pvtsvcconn${local.storage_account_name}"
    private_connection_resource_id = azurerm_storage_account.fileshare_storage.id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }
}

resource "azurerm_private_dns_a_record" "dns_a" {
  count               = var.create_private_dns_zone == true ? 1 : 0
  name                = "fileshare${local.storage_account_name}"
  zone_name           = azurerm_private_dns_zone.private_dnszone[count.index].name
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.endpoint[count.index].private_service_connection.0.private_ip_address]

}

/** TO DO .... 

resource "azurerm_storage_account_customer_managed_key" "example" {
  storage_account_id = azurerm_storage_account.example.id
  key_vault_id       = azurerm_key_vault.example.id
  key_name           = azurerm_key_vault_key.example.name
}

**/


resource "azurerm_ssh_public_key" "ssh_key" {
  name = "testpubkey"
  resource_group_name = local.resource_group_name
  location = local.location
  public_key = file(var.pub_key_path)
}

