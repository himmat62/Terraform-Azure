output "storage_account_id" {
  description = "Created Storage Account ID."
  value       = azurerm_storage_account.lz-storage.id
}

output "storage_file_shares" {
  description = "Created file shares in the Storage Account."
  value       = azurerm_storage_share.file_shares
}

output "filesharestorage_endpoint" {
  description = "The primary blob endpoint."
  value       = azurerm_storage_account.lz-storage.primary_file_endpoint
}

output "my_ip" {
  value = data.http.ip.response_body
}

