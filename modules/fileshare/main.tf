locals {
  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type = (local.account_tier == "Premium" ? "ZRS" : split("_", var.skuname)[1])
  resource_group_name      = element(coalescelist(data.azurerm_resource_group.rg-rsf.*.name, azurerm_resource_group.rg-new.*.name, [""]), 0)
  location                 = element(coalescelist(data.azurerm_resource_group.rg-rsf.*.location, azurerm_resource_group.rg-new.*.location, [""]), 0)


}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
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
  name                      = "${var.storage_account_name}${random_string.unique.result}"
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = var.account_kind
  account_tier              = local.account_tier #TransactionOptimized, Hot,Cool, Premium
  account_replication_type  = local.account_replication_type
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  public_network_access_enabled = var.public_network_access_enabled 

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

## Advance Threat protection

resource "azurerm_advanced_threat_protection" "atp" {
  target_resource_id = azurerm_storage_account.lz-storage.id
  enabled            = var.enable_advanced_threat_protection
}

resource "azurerm_storage_account_network_rules" "net_rules" {
  count =   var.public_network_access_enabled == true ? 1 : 0
  storage_account_id         = azurerm_storage_account.lz-storage.id
      default_action             = var.network_rules.default_action
      bypass                     = var.network_rules.bypass
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids
}






