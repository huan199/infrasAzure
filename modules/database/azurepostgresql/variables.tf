variable "postgresql_config" {
  description = "Cấu hình Azure Database for PostgreSQL Flexible Server"
  type = list(object({
    server_name             = string
    resource_group_name     = string
    location                = string
    administrator_login     = string
    administrator_password  = string
    sku_name                = string
    version                 = string
    zone                    = string
    storage_mb              = number
  backup_retention_days   = number
  public_network_access_enabled = bool
  database_name           = string
  charset                 = string
  collation               = string
  start_ip_address        = string
  end_ip_address          = string
  }))
  default = []
}
