output "my_ip" {
  value = module.StorageFileshare.my_ip
}

output "storage_account_id" {
  description = "The ID of the storage account."
  value = module.StorageFileshare.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value = module.StorageFileshare.storage_account_name
}

output "file_shares_list" {
  description = "Map of Storage SMB file shares"
  value = module.StorageFileshare.storage_file_shares
}

output "primary_file_endpoint" {
  description = "The primary fileshare endpoint."
  value       = module.StorageFileshare.primary_file_endpoint
}

output "primary_file_host" {
  description = "The primary file host"
  value = module.StorageFileshare.primary_file_host
}

output "storage_primary_connection_string" {
  description = "The primary connection string for the storage account"
  value = module.StorageFileshare.storage_primary_connection_string
  sensitive   = true
}

output "storage_primary_access_key" {
  description = "The primary access key for the storage account"
  value = module.StorageFileshare.storage_primary_access_key
  sensitive   = true
}








