<<<<<<< HEAD
output "file_shares_list" {
  value = { for fileshare in azurerm_storage_share.lz-fileshare : fileshare.name => fileshare.quota }
=======
/**
output "file_shares_list" {
  value = { for fileshare in azurerm_storage_account.lz-storage : fileshare.name[] }
} **/


output "my_ip" {
  value = data.http.ip.response_body
>>>>>>> 6b07966 (adding gitignore)
}


