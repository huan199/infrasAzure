resource "azurerm_bastion_host" "bastion_details" {
  name                = var.bastion.bastion_name
  location            = var.bastion.location
  resource_group_name = var.bastion.resource_group_name
  sku                 = var.bastion.sku

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion.subnet_id
    public_ip_address_id = var.bastion.public_ip_id
  }
}
