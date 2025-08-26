resource "azurerm_application_gateway" "this" {
  name                = var.appgateway_config.appgw_name
  resource_group_name = var.appgateway_config.resource_group_name
  location            = var.appgateway_config.location
  sku {
    name     = var.appgateway_config.sku_name
    tier     = var.appgateway_config.sku_tier
    capacity = var.appgateway_config.capacity
  }
  gateway_ip_configuration {
    name      = "appgw-ipcfg"
    subnet_id = var.appgateway_config.subnet_id
  }
  frontend_port {
    name = "frontendPort"
    port = 80
  }
  frontend_ip_configuration {
    name                 = "appgw-feip"
    public_ip_address_id = var.appgateway_config.public_ip_id
  }
  backend_address_pool {
    name  = "default-backend-pool"
  }
  backend_http_settings {
    name                  = "default-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    pick_host_name_from_backend_address = false
  }
  http_listener {
    name                           = "default-listener"
    frontend_ip_configuration_name = "appgw-feip"
    frontend_port_name             = "frontendPort"
    protocol                      = "Http"
  }
  request_routing_rule {
    name                       = "default-rule"
    rule_type                  = "Basic"
    http_listener_name         = "default-listener"
    backend_address_pool_name  = "default-backend-pool"
    backend_http_settings_name = "default-http-settings"
    priority                   = 100
  }
}
