terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.73.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "http" {}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id            = var.hub_sub_id
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "identity"
  subscription_id            = var.identity_sub_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "management"
  subscription_id            = var.management_sub_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "hub"
  subscription_id            = var.hub_sub_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias                      = "rsf"
  subscription_id            = var.rsf_sub_id
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
