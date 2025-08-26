resource "random_integer" "sqlserver_suffix" {
  min = 1000
  max = 9999
}

resource "azurerm_mssql_server" "sqlserver" {
  for_each                     = {for detail in var.sql_database_details : detail.server_name => detail}
  name                         = each.value.server_name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = "12.0"
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_password
}

resource "azurerm_mssql_database" "database" {
  for_each   = {for detail in var.sql_database_details : detail.database_name => detail}
  name       = each.value.database_name
  server_id  = azurerm_mssql_server.sqlserver[each.value.server_name].id
  collation  = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb = 64
  sku_name   = each.value.database_sku
}

resource "azurerm_mssql_firewall_rule" "allow_access" {
  for_each         = {for detail in var.sql_database_details : detail.server_name => detail}
  name             = "AllowAll"
  server_id        = azurerm_mssql_server.sqlserver[each.key].id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}