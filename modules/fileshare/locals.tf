locals {
  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type = (local.account_tier == "Premium" ? "ZRS" : split("_", var.skuname)[1])
  resource_group_name      = element(coalescelist(data.azurerm_resource_group.rg-rsf.*.name, azurerm_resource_group.rg-new.*.name, [""]), 0)
  location                 = element(coalescelist(data.azurerm_resource_group.rg-rsf.*.location, azurerm_resource_group.rg-new.*.location, [""]), 0)
  storage_account_name     = lower(var.storage_account_name)

  cors_settings = var.file_share_cors_rules
  smb_settings = var.file_share_properties_smb

}