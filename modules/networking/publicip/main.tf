resource "azurerm_public_ip" "public_ip" {
  for_each            = { for ip in var.public_ip_config : ip.name => ip }
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}
