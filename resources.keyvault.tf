data "azurerm_client_config" "current" {}

/**
#KeyVault for Hub Subscription 
resource "random_string" "azurerm_key_vault_hub_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_key_vault" "hub_vault" {
  provider = azurerm.hub

  for_each = local.default_resource_groups_hub
  #name must be between 3-24
  name                = "kv-${each.value.name}-${random_string.azurerm_key_vault_hub_name.result}"
  location            = local.location
  resource_group_name = each.value.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = local.keyvault_sku_pricing_tier
  //optional
  enabled_for_deployment          = local.enabled_for_deployment
  enabled_for_disk_encryption     = local.enabled_for_disk_encryption
  enabled_for_template_deployment = local.enabled_for_template_deployment
  purge_protection_enabled        = local.purge_protection_enabled
  soft_delete_retention_days      = local.soft_delete_retention_days
  enable_rbac_authorization       = local.enable_rbac_authorization

  dynamic "network_acls" {
    for_each = local.network_acls == null ? [] : [local.network_acls]
    content {
      bypass                     = local.network_acls.bypass
      default_action             = local.network_acls.default_action
      ip_rules                   = local.network_acls.ip_rules
      virtual_network_subnet_ids = local.network_acls.virtual_network_subnet_ids
    }
  }

  dynamic "access_policy" {
    for_each = var.kv_access_policies
    content {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = local.current_user_id
      key_permissions         = local.key_permissions
      secret_permissions      = local.secret_permissions
      certificate_permissions = local.certificate_permissions
      storage_permissions     = local.storage_permissions
    }
  }

  tags = local.base_options.rg.tags
}



#Keyvault for Management Subscription

resource "random_string" "azurerm_key_vault_mgmt_name" {
  length  = 10
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_key_vault" "mgmt_vault" {
  provider = azurerm.management

  for_each = local.default_resource_groups_management
  #name must be between 3-24
  name                = "kv-${each.value.name}-${random_string.azurerm_key_vault_mgmt_name.result}"
  location            = local.location
  resource_group_name = each.value.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = local.keyvault_sku_pricing_tier
  //optional
  enabled_for_deployment          = local.enabled_for_deployment
  enabled_for_disk_encryption     = local.enabled_for_disk_encryption
  enabled_for_template_deployment = local.enabled_for_template_deployment
  purge_protection_enabled        = local.purge_protection_enabled
  soft_delete_retention_days      = local.soft_delete_retention_days
  enable_rbac_authorization       = local.enable_rbac_authorization


  dynamic "network_acls" {
    for_each = local.network_acls == null ? [] : [local.network_acls]
    content {
      bypass                     = local.network_acls.bypass
      default_action             = local.network_acls.default_action
      ip_rules                   = local.network_acls.ip_rules
      virtual_network_subnet_ids = local.network_acls.virtual_network_subnet_ids
    }
  }

  access_policy {
    tenant_id               = data.azurerm_client_config.current.tenant_id
    object_id               = local.current_user_id
    key_permissions         = local.key_permissions
    secret_permissions      = local.secret_permissions
    certificate_permissions = local.certificate_permissions
    storage_permissions     = local.storage_permissions
  }
  tags = local.base_options.rg.tags
}


## Keyvault for Identity Subscription

resource "random_string" "azurerm_key_vault_identity_name" {
  length  = 10
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_key_vault" "identity_vault" {
  provider = azurerm.identity

  for_each = local.default_resource_groups_identity
  #name must be between 3-24
  name                = "kv-${each.value.name}-${random_string.azurerm_key_vault_identity_name.result}"
  location            = local.location
  resource_group_name = each.value.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = local.keyvault_sku_pricing_tier
  //optional
  enabled_for_deployment          = local.enabled_for_deployment
  enabled_for_disk_encryption     = local.enabled_for_disk_encryption
  enabled_for_template_deployment = local.enabled_for_template_deployment
  purge_protection_enabled        = local.purge_protection_enabled
  soft_delete_retention_days      = local.soft_delete_retention_days
  enable_rbac_authorization       = local.enable_rbac_authorization


  dynamic "network_acls" {
    for_each = local.network_acls == null ? [] : [local.network_acls]
    content {
      bypass                     = local.network_acls.bypass
      default_action             = local.network_acls.default_action
      ip_rules                   = local.network_acls.ip_rules
      virtual_network_subnet_ids = local.network_acls.virtual_network_subnet_ids
    }
  }

  access_policy {
    tenant_id               = data.azurerm_client_config.current.tenant_id
    object_id               = local.current_user_id
    key_permissions         = local.key_permissions
    secret_permissions      = local.secret_permissions
    certificate_permissions = local.certificate_permissions
    storage_permissions     = local.storage_permissions
  }

  tags = local.base_options.rg.tags
}

**/



