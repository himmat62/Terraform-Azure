/**
output "storage_file_shares" {
  description = "Created file shares in the Storage Account."
  value       = azurerm_storage_share.file_shares
}

output "my_ip" {
  value = data.http.ip.response_body
}

output "filesharestorage_endpoint" {
  description = "The primary blob endpoint."
  value       = azurerm_storage_account.lz-storage.primary_file_endpoint
}

output "id" {
  description = "The ID of the newly created Storage Account."
  value       = azurerm_storage_account.lz-storage.id
}

**/
