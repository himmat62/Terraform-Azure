

module "fileshare" {

  providers = {
    azurerm = azurerm.rsf
  }

  source = "./modules/fileshare"

  create_resource_group = true
  #resource_group_name   = "rsf"
  location = "uksouth"
  #storage_account_name  = "mydefaultstorage"
  enable_advanced_threat_protection = true

  public_network_access_enabled = true ## after disable public access it will not allow not to enable
  
  //optional 
  network_rules = {
    default_action = "Deny"
    ip_rules       = ["217.164.2.107"]

  }

  file_shares = [
    { name = "test", quota = 100 },
    #{ name = "smbfileshare2", quota = 50 }
  ]

  tags = {
    ProjectName = "londonalz"
    Env         = "test"
    Owner       = "himmat"
  }

}