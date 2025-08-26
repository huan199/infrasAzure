variable "appgateway_config" {
  description = "Cấu hình Application Gateway dạng object"
  type = object({
    public_ip_id        = string
    resource_group_name = string
    location           = string
    appgw_name         = string
    sku_name           = string
    sku_tier           = string
    capacity           = number
    subnet_id          = string
  })
}