
locals {
  #resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  #current_user_id = coalesce(var.kv_access_policies.object_id, data.azurerm_client_config.current.object_id)
  #tenant_id   = coalesce(var.tenant_id, data.azurerm_client_config.current_config.tenant_id)
  resource_group_name_rsf  = element(coalescelist(data.azurerm_resource_group.rg-rsf.*.name, azurerm_resource_group.rg-new_rsf.*.name, [""]), 0)
  resource_group_name_hub  = element(coalescelist(data.azurerm_resource_group.rg-hub.*.name, azurerm_resource_group.rg-new_hub.*.name, [""]), 0)
  resource_group_name_mgmt = element(coalescelist(data.azurerm_resource_group.rg-mgmt.*.name, azurerm_resource_group.rg-new_mgmt.*.name, [""]), 0)
  #resource_group_name_identity = element(coalescelist(data.azurerm_resource_group.rg-identity.*.name, azurerm_resource_group.rg-new_identity.*.name, [""]), 0)
}