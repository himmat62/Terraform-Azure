output "file_shares_list" {
  value = { for fileshare in azurerm_storage_share.lz-fileshare : fileshare.name => fileshare.quota }
}


