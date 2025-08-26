variable "resource_group" {
  type = map(object({
    location = string
  }))
}

variable "platform" {
  type = map(object({
    virtual_network_address_space = string
    resource_group_name            = string
    location                       = string
    subnets                        = map(object({
      subnet_name          = string
      subnet_address_prefix = string
      network_security_group_rules = list(object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
      }))
    }))
  }))
}
variable "network_security_group_details" {
  type = list(object({
    subnet_name              = string
    location                 = string
    resource_group_name      = string
    network_security_group_rules = list(object({
      name                       = string
      direction                  = string
      priority                   = number
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  default = []
}
variable "log_analytics_workspaces" {
  type = map(object({
    location            = string
    resource_group_name = string
  }))
}

variable "vnet_peering_details" {
  type = list(object({
    peering_name                  = string
    resource_group_name           = string
    virtual_network_name          = string
    remote_virtual_network_id     = string
    allow_virtual_network_access  = bool
    allow_forwarded_traffic       = bool
    allow_gateway_transit         = bool
    use_remote_gateways           = bool
  }))
}

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

variable "subscription_id" {
  description = "The ID of the Azure subscription"
  type        = string
}

variable "rg_role_bindings" {
  description = "List of RBAC assignments at resource group level"
  type = list(object({
    subscription_id      = string
    rg_name              = string
    role_definition_name = string
    principal_id         = string
  }))
  default = []
}