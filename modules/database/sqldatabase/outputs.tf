output "sql_server_names" {
	value = { for k, v in azurerm_mssql_server.sqlserver : k => v.name }
}

output "sql_database_names" {
	value = { for k, v in azurerm_mssql_database.database : k => v.name }
}

output "sql_server_fqdns" {
	value = { for k, v in azurerm_mssql_server.sqlserver : k => v.fully_qualified_domain_name }
}
