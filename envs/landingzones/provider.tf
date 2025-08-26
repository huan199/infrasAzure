terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "5a15c534-3b59-4499-8747-f6485182b7ef"
}