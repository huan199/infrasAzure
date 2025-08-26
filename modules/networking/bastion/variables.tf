variable "bastion" {
  description = "Cấu hình Bastion Host"
  type = object({
    bastion_name        = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    public_ip_id        = string
    sku                 = optional(string, "Standard")
  
  })
}