variable "sql_database_details" {
  description = "Danh sách các SQL Server/Database cần tạo."
  type = list(object({
    server_name            = string
    database_name          = string
    resource_group_name    = string
    location               = string
    database_sku           = string
    administrator_login    = string
    administrator_password = string
    start_ip_address       = string
    end_ip_address         = string
  }))
}