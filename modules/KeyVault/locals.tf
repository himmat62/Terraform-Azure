locals {
  #current_user_id = coalesce(var.kv_access_policies.object_id, data.azurerm_client_config.current.object_id)
  #tenant_id   = coalesce(var.tenant_id, data.azurerm_client_config.current_config.tenant_id)
  resource_group_name = element(coalescelist(data.azurerm_resource_group.kv_rg.*.name, azurerm_resource_group.kv_rg_new.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.kv_rg.*.location, azurerm_resource_group.kv_rg_new.*.location, [""]), 0)
}