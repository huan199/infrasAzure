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
module "logging" {
  source = "../../modules/monitoring/logging"
  log_analytics_workspaces = var.log_analytics_workspaces
}

module "vnetpeering" {
  source = "../../modules/networking/vnetpeering"
  vnet_peering_details = var.vnet_peering_details
  depends_on = [module.resource_group, module.network]
}

module "public_ip" {
  source = "../../modules/networking/publicip"
  public_ip_config = var.public_ip_config
  depends_on = [module.resource_group, module.network]
}

/*
 module "bastion" {
   source = "../../modules/networking/bastion"
   bastion = var.bastion
   depends_on = [module.resource_group, module.network, module.public_ip]
}
*/

module "application_gateway" {
  source = "../../modules/networking/appgateway"
  appgateway_config = var.appgateway_config
  depends_on = [module.resource_group,module.network, module.public_ip]
}

module "azure_firewall" {
  source          = "../../modules/networking/firewall"
  firewall_config = var.firewall_config
}

resource "azurerm_monitor_diagnostic_setting" "firewall_logs" {
  name                       = "firewall-logs"
  target_resource_id         = module.azure_firewall.firewall_id
  log_analytics_workspace_id = module.logging.workspace_ids["security-log-workspaces"]

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }
  enabled_log {
    category = "AzureFirewallNetworkRule"
  }
  enabled_log {
    category = "AzureFirewallDnsProxy"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "appgw_waf_logs" {
  name                       = "appgw-waf-logs"
  target_resource_id         = module.application_gateway.appgw_id
  log_analytics_workspace_id = module.logging.workspace_ids["security-log-workspaces"]

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }
}

module "rbac" {
  source            = "../../modules/general/rbac"
  subscription_id   = var.subscription_id
  rg_role_bindings  = var.rg_role_bindings
  depends_on = [module.resource_group]
}

