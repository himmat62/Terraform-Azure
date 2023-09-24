module "StorageFileshare" {

  providers = {
    azurerm = azurerm.rsf
  }

  source = "./modules/StorageFileshare"

  create_resource_group = true
  #resource_group_name   = "rsf"
  location     = "uksouth"
  account_kind = "FileStorage"
  #skuname = "Standard_LRS"
  #storage_account_name  = "mydefaultstorage"

  enable_advanced_threat_protection = false ##Microsoft defender for storage sensitve data threat detection and on-uploading malware scanning 
  public_network_access_enabled     = true  ## after disable public access it will not allow to enable back untill client ip not added

  //optional 
  network_rules = {
    default_action = "Allow"
    bypass         = ["AzureServices"]
    ip_rules       = ["217.164.2.107"] #["PublicIP", data.http.ip.response_body]  Supports IPv4 address but not ipv6

  }
  file_shares = [
    {
      name        = "share-smb"
      quota_in_gb = 100
    },
    {
      name             = "share-nfs"
      quota_in_gb      = 100
      enabled_protocol = "NFS" # Note that NFS file shares are not backed up due to Azure limitation 
    }
  ]


  ##private endpoint enabled if public_network_access_enabled = false

  create_private_dns_zone  = true
  fileshare_resource_group = "example-resources"
  fileshare_vnet_name      = "example-network"
  fileshare_subnet_name    = "endpoint_subnet"

  tags = {
    ProjectName = "londonalz"
    Env         = "test"
    Owner       = "himmat"
  }

}