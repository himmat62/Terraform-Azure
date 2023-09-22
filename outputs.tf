output "my_ip" {
  value = module.fileshare.my_ip
}


output "file_shares_list" {
  value = module.fileshare.storage_file_shares
}

output "filesharestorage_endpoint" {
  description = "The primary blob endpoint."
  value       = module.fileshare.filesharestorage_endpoint
}



