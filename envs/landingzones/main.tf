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

module "azure-storage" {
  source = "../../modules/storage/azurestorage"
  storage_accounts = var.storage_accounts
  depends_on = [ module.resource_group, module.network ]
}

module "vnetpeering" {
  source = "../../modules/networking/vnetpeering"
  vnet_peering_details = var.vnet_peering_details
  depends_on = [module.network]
}

module "postgres" {
  source = "../../modules/database/azurepostgresql"
  postgresql_config = var.postgresql_config
  depends_on = [module.resource_group]
}

module "database" {
  source = "../../modules/database/sqldatabase"
  sql_database_details = var.sql_database_details
  depends_on = [module.resource_group]
}

module "rbac" {
  source            = "../../modules/general/rbac"
  subscription_id   = var.subscription_id
  rg_role_bindings  = var.rg_role_bindings
  depends_on = [ module.resource_group ]
}

