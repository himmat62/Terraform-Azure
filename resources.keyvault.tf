data "azurerm_client_config" "current" {}

#KeyVault for RSF Subscription 

data "azurerm_resource_group" "rg-rsf" {
  provider = azurerm.rsf
  count    = var.create_resource_group == false ? 1 : 0
  name     = var.resource_group_name_rsf
}

resource "azurerm_resource_group" "rg-new_rsf" {
  provider = azurerm.rsf
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name_rsf)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name_rsf) }, var.tags)
}


resource "random_string" "azurerm_key_vault_rsf_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_key_vault" "rsf_vault" {
  provider = azurerm.rsf
  #name must be between 3-24
  name                = "kv-${var.resource_group_name_rsf}-${random_string.azurerm_key_vault_rsf_name.result}"
  location            = local.location
  resource_group_name = local.resource_group_name_rsf
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku_pricing_tier

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  enable_rbac_authorization       = var.rbac_authorization_enabled

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [true] : []
    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  }

  dynamic "contact" {
    for_each = var.certificate_contacts
    content {
      email = contact.value.email
      name  = contact.value.name
      phone = contact.value.phone
    }
  }

  tags = local.base_options.rg.tags
}

# Create a Default Azure Key Vault access policy with Admin permissions
# This policy must be kept for a proper run of the "destroy" process
resource "azurerm_key_vault_access_policy" "default_policy" {
  count        = var.rbac_authorization_enabled == false ? 1 : 0
  key_vault_id = azurerm_key_vault.rsf_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = var.kv-key-permissions-full
  secret_permissions      = var.kv-secret-permissions-full
  certificate_permissions = var.kv-certificate-permissions-full
  storage_permissions     = var.kv-storage-permissions-full
  lifecycle {
    create_before_destroy = true
  }
}

# Create an Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "policy" {
  for_each                = { for key, value in var.access_policies : key => value }
  key_vault_id            = azurerm_key_vault.rsf_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = lookup(each.value, "object_id")
  key_permissions         = lookup(each.value, "key_permissions")
  secret_permissions      = lookup(each.value, "secret_permissions")
  certificate_permissions = lookup(each.value, "certificate_permissions")
  storage_permissions     = lookup(each.value, "storage_permissions")
}

/**
resource "azurerm_key_vault_key" "cmk_key" {
  name         = "tfex-key"
  key_vault_id = azurerm_key_vault.rsf_vault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_key_vault_access_policy.default_policy
  ]
}**/
##########################################

#KeyVault for HUB Subscription

data "azurerm_resource_group" "rg-hub" {
  provider = azurerm.hub
  count    = var.create_resource_group == false ? 1 : 0
  name     = var.resource_group_name_hub
}

resource "azurerm_resource_group" "rg-new_hub" {
  provider = azurerm.hub
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name_hub)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name_hub) }, var.tags)
}

resource "random_string" "azurerm_key_vault_hub_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_key_vault" "hub_vault" {
  provider = azurerm.hub
  #name must be between 3-24
  name                = "kv-${var.resource_group_name_hub}-${random_string.azurerm_key_vault_hub_name.result}"
  location            = local.location
  resource_group_name = local.resource_group_name_hub
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku_pricing_tier

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  enable_rbac_authorization       = var.rbac_authorization_enabled

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [true] : []
    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  }

  dynamic "contact" {
    for_each = var.certificate_contacts
    content {
      email = contact.value.email
      name  = contact.value.name
      phone = contact.value.phone
    }
  }

  tags = local.base_options.rg.tags
}

# Create a Default Azure Key Vault access policy with Admin permissions
# This policy must be kept for a proper run of the "destroy" process
resource "azurerm_key_vault_access_policy" "default_policy_hub" {
  count        = var.rbac_authorization_enabled == false ? 1 : 0
  key_vault_id = azurerm_key_vault.hub_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = var.kv-key-permissions-full
  secret_permissions      = var.kv-secret-permissions-full
  certificate_permissions = var.kv-certificate-permissions-full
  storage_permissions     = var.kv-storage-permissions-full
  lifecycle {
    create_before_destroy = true
  }
}

# Create an Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "policy_hub" {
  for_each                = { for key, value in var.access_policies : key => value }
  key_vault_id            = azurerm_key_vault.hub_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = lookup(each.value, "object_id")
  key_permissions         = lookup(each.value, "key_permissions")
  secret_permissions      = lookup(each.value, "secret_permissions")
  certificate_permissions = lookup(each.value, "certificate_permissions")
  storage_permissions     = lookup(each.value, "storage_permissions")
}

##########################################

#KeyVault for Management Subscription

data "azurerm_resource_group" "rg-mgmt" {
  provider = azurerm.management
  count    = var.create_resource_group == false ? 1 : 0
  name     = var.resource_group_name_mgmt
}

resource "azurerm_resource_group" "rg-new_mgmt" {
  provider = azurerm.management
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name_mgmt)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name_mgmt) }, var.tags)
}

resource "random_string" "azurerm_key_vault_mgmt_name" {
  length  = 5
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_key_vault" "mgmt_vault" {
  provider = azurerm.management
  #name must be between 3-24
  name                = "kv-${var.resource_group_name_mgmt}-${random_string.azurerm_key_vault_mgmt_name.result}"
  location            = local.location
  resource_group_name = local.resource_group_name_mgmt
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku_pricing_tier

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  enable_rbac_authorization       = var.rbac_authorization_enabled

  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [true] : []
    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  }

  dynamic "contact" {
    for_each = var.certificate_contacts
    content {
      email = contact.value.email
      name  = contact.value.name
      phone = contact.value.phone
    }
  }

  tags = local.base_options.rg.tags
}

# Create a Default Azure Key Vault access policy with Admin permissions
# This policy must be kept for a proper run of the "destroy" process
resource "azurerm_key_vault_access_policy" "default_policy_mgmt" {
  count        = var.rbac_authorization_enabled == false ? 1 : 0
  key_vault_id = azurerm_key_vault.mgmt_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = var.kv-key-permissions-full
  secret_permissions      = var.kv-secret-permissions-full
  certificate_permissions = var.kv-certificate-permissions-full
  storage_permissions     = var.kv-storage-permissions-full
  lifecycle {
    create_before_destroy = true
  }
}

# Create an Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "policy_mgmt" {
  for_each                = { for key, value in var.access_policies : key => value }
  key_vault_id            = azurerm_key_vault.mgmt_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = lookup(each.value, "object_id")
  key_permissions         = lookup(each.value, "key_permissions")
  secret_permissions      = lookup(each.value, "secret_permissions")
  certificate_permissions = lookup(each.value, "certificate_permissions")
  storage_permissions     = lookup(each.value, "storage_permissions")
}

## Keyvault for Identity Subscription


