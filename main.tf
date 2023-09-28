module "StorageFileshare" {

  providers = {
    azurerm = azurerm.rsf
  }

  source = "./modules/StorageFileshare"

  create_resource_group = true
  resource_group_name   = "rsf"
  location              = "uksouth"
  account_kind          = "FileStorage"
  #skuname = "Standard_LRS"
  #storage_account_name  = "mydefaultstorage"

  enable_advanced_threat_protection = false ##Microsoft defender for storage sensitve data threat detection and on-uploading malware scanning 
  public_network_access_enabled     = true  ## after disable public access it will not allow to enable back untill client ip not added

  //optional 
  network_rules = {
    #default_action = "Allow"
    bypass         = ["AzureServices"]
    ip_rules       = ["217.164.2.107"] #["PublicIP", data.http.ip.response_body]  Supports IPv4 address but not ipv6

  }

  file_shares = [
    {
      name        = "share-smb"
      quota_in_gb = 100
    },
    /**{
      name             = "share-nfs"
      quota_in_gb      = 100
      enabled_protocol = "NFS" # Note that NFS file shares are not backed up due to Azure limitation 
    }**/
  ]


  ##private endpoint enabled if public_network_access_enabled = false

  create_private_dns_zone  = false
  fileshare_resource_group = "example-resources"
  fileshare_vnet_name      = "example-network"
  fileshare_subnet_name    = "endpoint_subnet"

  tags = {
    ProjectName = "londonalz"
    Env         = "test"
    Owner       = "himmat"
  }

}

module "keyvault_rsf" {

  providers = {
    azurerm = azurerm.rsf
  }

  source = "./modules/KeyVault"

}


module "kv_private_dns_zone" {
  providers = {
    azurerm = azurerm.rsf
  }  

  source  = "./modules/private-dns-zone"

  resource_group_name = azurerm_resource_group.rsf-rg["rsf"].name

  private_dns_zone_name      = "privatelink.vaultcore.azure.net"
  private_dns_zone_vnets_ids = ["/subscriptions/6b350204-f4f4-4e94-add6-5a1aa8a16e6c/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-network"]

   tags = {
    ProjectName = "londonalz"
    Env         = "test"
    Owner       = "himmat"
  }
}

module "storage_private_dns_zone" {
  providers = {
    azurerm = azurerm.rsf
  }  

  source  = "./modules/private-dns-zone"

  resource_group_name = azurerm_resource_group.rsf-rg["rsf"].name

  private_dns_zone_name      = "privatelink.file.core.windows.net"
  private_dns_zone_vnets_ids = ["/subscriptions/6b350204-f4f4-4e94-add6-5a1aa8a16e6c/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-network"]

   tags = {
    ProjectName = "londonalz"
    Env         = "test"
    Owner       = "himmat"
  }
}
/**
module "storage_privateendpoint" {
  providers = {
    azurerm = azurerm.rsf
  }  
}
**/