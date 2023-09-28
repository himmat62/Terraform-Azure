resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection_name
    private_connection_resource_id = var.resouce_id
    subresource_names              = var.subresource_name
    is_manual_connection           = var.is_manual_connection
  }

  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = var.private_dns_zones_ids
  }
}
/**
resource "azurerm_private_dns_a_record" "dns_a" {
  name                = "fileshare${local.storage_account_name}"
  zone_name           = var.private_dns_zones_names
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint[*].private_service_connection.0.private_ip_address]

}**/