resource "azurerm_firewall" "this" {
  name                = var.firewall_config.firewall_name
  location            = var.firewall_config.location
  resource_group_name = var.firewall_config.resource_group_name
  sku_name            = var.firewall_config.sku_name
  sku_tier            = var.firewall_config.sku_tier

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_config.subnet_id
    public_ip_address_id = var.firewall_config.public_ip_id
  }

  lifecycle {
    ignore_changes = [
      ip_configuration,
      dns_proxy_enabled,
      dns_servers,
      private_ip_ranges,
      threat_intel_mode
      # Không liệt kê network_rule_collection, application_rule_collection, nat_rule_collection ở đây!
    ]
  }
}