output "storage_account_id" {
  description = "Created Storage Account ID."
  value       = azurerm_storage_account.fileshare_storage.id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value = azurerm_storage_account.fileshare_storage.name
  
}
/**
output "storage_file_shares" {
  description = "Created file shares in the Storage Account."
  value       = azurerm_storage_share.file_shares
}**/

output "storage_file_shares" {
  description = "Map of Storage SMB file shares."
  value       = { for f in azurerm_storage_share.file_shares : f.name => f.id }
}

output "storage_account_primary_location" {
  description = "The primary location of the storage account"
  value       = azurerm_storage_account.fileshare_storage.primary_location
}

output "storage_primary_connection_string" {
  description = "The primary connection string for the storage account"
  value       = azurerm_storage_account.fileshare_storage.primary_connection_string
  sensitive   = true
}

output "storage_primary_access_key" {
  description = "The primary access key for the storage account"
  value       = azurerm_storage_account.fileshare_storage.primary_access_key
  sensitive   = true
}

output "storage_secondary_access_key" {
  description = "The primary access key for the storage account."
  value       = azurerm_storage_account.fileshare_storage.secondary_access_key
  sensitive   = true
}

output "primary_file_endpoint" {
  description = "The primary file endpoint."
  value       = azurerm_storage_account.fileshare_storage.primary_file_endpoint
}

output "primary_file_host" {
  description = "the primary file host"
  value = azurerm_storage_account.fileshare_storage.primary_file_host
  
}

output "my_ip" {
  value = data.http.ip.response_body
}

