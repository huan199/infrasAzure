resource "azurerm_postgresql_flexible_server" "postgres" {
  for_each = { for idx, cfg in var.postgresql_config : idx => cfg }
  name                   = each.value.server_name
  resource_group_name    = each.value.resource_group_name
  location               = each.value.location
  administrator_login    = each.value.administrator_login
  administrator_password = each.value.administrator_password
  sku_name               = each.value.sku_name
  version                = each.value.version
  zone                   = each.value.zone
  storage_mb             = each.value.storage_mb
  backup_retention_days  = each.value.backup_retention_days
  public_network_access_enabled = each.value.public_network_access_enabled
}


resource "azurerm_postgresql_flexible_server_database" "db" {
  for_each = { for idx, cfg in var.postgresql_config : idx => cfg }
  name      = each.value.database_name
  server_id = azurerm_postgresql_flexible_server.postgres[each.key].id
  collation = "en_US.utf8"
  charset   = "UTF8"
}


resource "azurerm_postgresql_flexible_server_firewall_rule" "allowall" {
  for_each = { for idx, cfg in var.postgresql_config : idx => cfg }
  name                = "AllowAll"
  server_id           = azurerm_postgresql_flexible_server.postgres[each.key].id
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}
