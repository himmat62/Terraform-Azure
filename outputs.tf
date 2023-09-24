/**
output "my_ip" {
  value = module.StorageFileshare.my_ip
}


output "file_shares_list" {
  value = module.StorageFileshare.storage_file_shares
}

output "filesharestorage_endpoint" {
  description = "The primary blob endpoint."
  value       = module.StorageFileshare.filesharestorage_endpoint
}

**/



