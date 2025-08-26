terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.36.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "57388369-0905-4b81-9ea7-a7ae033d3bff"
}