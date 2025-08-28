variable "resource_group" {
  type = map(object({
    location = string
  }))
}

variable "sandbox" {
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

variable "app_config" {
  description = "App configuration object"
  type = object({
    resource_group_name = string
    location           = string
    service_details    = list(string)
    webapp_name        = string
  })
}