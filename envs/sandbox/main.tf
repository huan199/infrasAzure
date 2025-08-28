module "resource_group" {
  source = "../../modules/general/resourcegroups"
  resource_group = var.resource_group
}

module "network" {
  source = "../../modules/networking/vnet"
  virtual_network_details = local.virtual_network_details
  subnet_details          = local.subnet_details
  network_security_group_details = local.network_security_group_details
  depends_on = [ module.resource_group ]
}

module "vnetpeering" {
  source = "../../modules/networking/vnetpeering"
  vnet_peering_details = var.vnet_peering_details
  depends_on = [module.resource_group, module.network]
}

module "rbac" {
  source            = "../../modules/general/rbac"
  subscription_id   = var.subscription_id
  rg_role_bindings  = var.rg_role_bindings
  depends_on = [ module.resource_group ]
}

resource "azurerm_service_plan" "serviceplan" {  
  name                = var.app_config.service_details[0]
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  os_type             = var.app_config.service_details[2]
  sku_name            = var.app_config.service_details[1]
}




resource "azurerm_windows_web_app" "webapp" {
  name                = var.app_config.webapp_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  service_plan_id     = azurerm_service_plan.serviceplan.id
  
  site_config {
    always_on=false
     
    application_stack {
      current_stack="dotnet"
      dotnet_version="v8.0"
    }
  }  
}