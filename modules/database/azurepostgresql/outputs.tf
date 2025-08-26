output "postgresql_server_fqdn" {
  value = { for k, s in azurerm_postgresql_flexible_server.postgres : k => s.fqdn }
}

output "postgresql_server_id" {
  value = { for k, s in azurerm_postgresql_flexible_server.postgres : k => s.id }
}
