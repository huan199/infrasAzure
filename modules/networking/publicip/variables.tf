variable "public_ip_config" {
  description = "Danh sách cấu hình public IP"
  type = list(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    sku                 = string
  }))
}
