resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_links" {
  count = length(var.private_dns_zone_vnets_ids)

  name = format("%s-link", reverse(split("/", var.private_dns_zone_vnets_ids[count.index]))[0])

  resource_group_name = var.resource_group_name

  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.private_dns_zone_vnets_ids[count.index]

  tags = var.tags

}