
/**
locals {
  current_user_id = coalesce(var.kv_access_policies.object_id, data.azurerm_client_config.current.object_id)
}

locals {
  # Common settings
  keyvault_sku_pricing_tier       = var.configure_keyvault_resources.keyvault.config.keyvault_sku_pricing_tier
  enabled_for_deployment          = var.configure_keyvault_resources.keyvault.config.enabled_for_deployment
  enabled_for_disk_encryption     = var.configure_keyvault_resources.keyvault.config.enabled_for_disk_encryption
  enabled_for_template_deployment = var.configure_keyvault_resources.keyvault.config.enabled_for_template_deployment
  purge_protection_enabled        = var.configure_keyvault_resources.keyvault.config.purge_protection_enabled
  soft_delete_retention_days      = var.configure_keyvault_resources.keyvault.config.soft_delete_retention_days
  enable_rbac_authorization       = var.configure_keyvault_resources.keyvault.config.enable_rbac_authorization

  # Network acls
  network_acls               = var.configure_keyvault_resources.network_acls.config
  bypass                     = var.configure_keyvault_resources.network_acls.config.bypass
  default_action             = var.configure_keyvault_resources.network_acls.config.default_action
  ip_rules                   = var.configure_keyvault_resources.network_acls.config.ip_rules
  virtual_network_subnet_ids = var.configure_keyvault_resources.network_acls.config.virtual_network_subnet_ids

  #access policies

  key_permissions         = var.kv_access_policies.key_permissions
  certificate_permissions = var.kv_access_policies.certificate_permissions
  secret_permissions      = var.kv_access_policies.secret_permissions
  storage_permissions     = var.kv_access_policies.storage_permissions

}

**/