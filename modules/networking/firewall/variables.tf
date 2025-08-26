variable "firewall_config" {
  description = "Azure Firewall cấu hình dạng object"
  type = object({
    firewall_name        = string
    location            = string
    resource_group_name = string
    sku_name            = string
    sku_tier            = string
    subnet_id           = string
    public_ip_id        = string
  })
}