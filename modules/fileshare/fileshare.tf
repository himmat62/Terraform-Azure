locals {
  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type = (local.account_tier == "Premium" ? "ZRS" : split("_", var.skuname)[1])
  resource_group_name      = element(coalescelist(data.azurerm_resource_group.rg-rsf.*.name, azurerm_resource_group.rg-new.*.name, [""]), 0)
  location                 = element(coalescelist(data.azurerm_resource_group.rg-rsf.*.location, azurerm_resource_group.rg-new.*.location, [""]), 0)
  storage_account_name     = lower(var.storage_account_name)

}

data "http" "ip" {
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


resource "azurerm_storage_account" "lz-storage" {
  name                          = "${local.storage_account_name}${random_string.unique.result}"
  resource_group_name           = local.resource_group_name
  location                      = local.location
  account_kind                  = var.account_kind
  account_tier                  = local.account_tier #TransactionOptimized, Hot,Cool, Premium
  account_replication_type      = local.account_replication_type
  enable_https_traffic_only     = var.enable_https_traffic_only
  min_tls_version               = var.min_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  large_file_share_enabled = var.large_file_share_enabled

  tags = merge({ "ResourceName" = format("%s", local.resource_group_name) }, var.tags)

}

resource "azurerm_storage_share" "lz-fileshare" {
  for_each             = { for u in var.file_shares : u.name => u }
  name                 = each.key
  storage_account_name = azurerm_storage_account.lz-storage.name
  quota                = each.value.quota

  depends_on = [
    azurerm_storage_account.lz-storage
  ]

}

## Advance Threat protection Microsoft Defender enable 

resource "azurerm_advanced_threat_protection" "atp" {
  target_resource_id = azurerm_storage_account.lz-storage.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_storage_account_network_rules" "net_rules" {
  count                      = var.public_network_access_enabled == true ? 1 : 0
  storage_account_id         = azurerm_storage_account.lz-storage.id
  default_action             = var.network_rules.default_action
  bypass                     = var.network_rules.bypass
  ip_rules                   = var.network_rules.ip_rules
  virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids
  depends_on = [
    azurerm_storage_account.lz-storage
  ]
}

### Private DNS Zone creation 

resource "azurerm_private_dns_zone" "private_dnszone" {
  count               = var.create_private_dns_zone == true ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  count               = var.create_private_dns_zone == true ? 1 : 0
  name                  = "vnet_link_${local.storage_account_name}"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dnszone[count.index].name
  #virtual_network_id    = "/subscriptions/6b350204-f4f4-4e94-add6-5a1aa8a16e6c/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-network"
  virtual_network_id = data.azurerm_virtual_network.fileshare-vnet.id
}

resource "azurerm_private_endpoint" "endpoint" {
  count               = var.create_private_dns_zone == true ? 1 : 0
  name                = "pvtendpoint-${local.storage_account_name}"
  location            = local.location
  resource_group_name = local.resource_group_name
  #subnet_id           = "/subscriptions/6b350204-f4f4-4e94-add6-5a1aa8a16e6c/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-network/subnets/endpoint_subnet"
  subnet_id = data.azurerm_subnet.fileshare_snet.id


  private_service_connection {
    name                           = "pvtsvcconn${local.storage_account_name}"
    private_connection_resource_id = azurerm_storage_account.lz-storage.id
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






