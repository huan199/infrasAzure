resource_group = {
  "SecurityRG" = {
    location = "Southeast Asia"
  }
  "ManagementRG" = {
    location = "Southeast Asia"
  }
  "IdentityRG" = {
    location = "Southeast Asia"
  }
  "ConnectivityRG" = {
    location = "Southeast Asia"
  }
}


platform = {
  Hub-VNet = {
    virtual_network_address_space = "13.0.0.0/16"
    resource_group_name = "ConnectivityRG"
    location = "Southeast Asia"
    subnets = {
      Gateway = {
        subnet_name = "Gateway"
        subnet_address_prefix = "13.0.1.0/24"
        network_security_group_rules = []
      }
      AzureBastion = {
        subnet_name = "AzureBastion"
        subnet_address_prefix = "13.0.2.0/24"
        network_security_group_rules = []
      }
      AzureFirewall = {
        subnet_name = "AzureFirewall"
        subnet_address_prefix = "13.0.3.0/24"
        network_security_group_rules = []
      }
      ApplicationGateway = {
        subnet_name = "ApplicationGateway"
        subnet_address_prefix = "13.0.4.0/24"
        network_security_group_rules = []
      }
    }
  }
  Identity-VNet = {
    virtual_network_address_space = "13.1.0.0/16"
    resource_group_name = "IdentityRg"
    location = "Southeast Asia"
    subnets = {
      AD = {
        subnet_name = "IdentityAD"
        subnet_address_prefix = "13.1.0.0/24"
        network_security_group_rules = [
          {
            name = "AllowADTraffic"
            priority = 100
            direction = "Inbound"
            access = "Allow"
            protocol = "*"
            source_port_range = "*"
            destination_port_range = "*"
            source_address_prefix = "*"
            destination_address_prefix = "*"
          }
        ]
      }
      Web = {
        subnet_name = "IdentityWeb"
        subnet_address_prefix = "13.1.1.0/24"
        network_security_group_rules = [
          {
            name = "AllowWebTraffic"
            priority = 200
            direction = "Inbound"
            access = "Allow"
            protocol = "*"
            source_port_range = "*"
            destination_port_range = "*"
            source_address_prefix = "*"
            destination_address_prefix = "*"
          }
        ]
      }
    }
  }
}
log_analytics_workspaces = {
  "security-log-workspaces" = {
    resource_group_name = "SecurityRG"
    location            = "Southeast Asia"
  }
  "central-logging-workspaces" = {
    resource_group_name = "ManagementRG"
    location            = "Southeast Asia"
  }
}

vnet_peering_details = [
  {
    peering_name                  = "hub-to-app01"
    resource_group_name           = "ConnectivityRG"
    virtual_network_name          = "Hub-VNet"
    remote_virtual_network_id     = "/subscriptions/5a15c534-3b59-4499-8747-f6485182b7ef/resourceGroups/App01RG/providers/Microsoft.Network/virtualNetworks/App01-VNet"
    allow_virtual_network_access  = true
    allow_forwarded_traffic       = true
    allow_gateway_transit         = false
    use_remote_gateways           = false
  },
  {
    peering_name                  = "hub-to-app02"
    resource_group_name           = "ConnectivityRG"
    virtual_network_name          = "Hub-VNet"
    remote_virtual_network_id     = "/subscriptions/5a15c534-3b59-4499-8747-f6485182b7ef/resourceGroups/App02RG/providers/Microsoft.Network/virtualNetworks/App02-VNet"
    allow_virtual_network_access  = true
    allow_forwarded_traffic       = true
    allow_gateway_transit         = false
    use_remote_gateways           = false
  },
  {
    peering_name                  = "hub-to-identity"
    resource_group_name           = "ConnectivityRG"
    virtual_network_name          = "Hub-VNet"
    remote_virtual_network_id     = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/IdentityRG/providers/Microsoft.Network/virtualNetworks/Identity-VNet"
    allow_virtual_network_access  = true
    allow_forwarded_traffic       = true
    allow_gateway_transit         = false
    use_remote_gateways           = false
  },
  {
    peering_name                  = "identity-to-hub"
    resource_group_name           = "IdentityRG"
    virtual_network_name          = "Identity-VNet"
    remote_virtual_network_id     = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/virtualNetworks/Hub-VNet"
    allow_virtual_network_access  = true
    allow_forwarded_traffic       = true
    allow_gateway_transit         = false
    use_remote_gateways           = false
  },
  {
    peering_name = "hub-to-apptest"
    resource_group_name = "ConnectivityRG"
    virtual_network_name = "Hub-VNet"
    remote_virtual_network_id = "/subscriptions/57388369-0905-4b81-9ea7-a7ae033d3bff/resourceGroups/AppTest/providers/Microsoft.Network/virtualNetworks/AppTest-VNet"
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    allow_gateway_transit = false
    use_remote_gateways = false
  }
]

public_ip_config = [ 
  {
  name                = "bastion-ip"
  location            = "Southeast Asia"
  resource_group_name = "ConnectivityRG"
  allocation_method   = "Static"
  sku                 = "Standard"
},
{
  name                = "firewall-ip"
  location            = "Southeast Asia"
  resource_group_name = "ConnectivityRG"
  allocation_method   = "Static"
  sku                 = "Standard"
},
{
  name                = "appgateway-ip"
  location            = "Southeast Asia"
  resource_group_name = "ConnectivityRG"
  allocation_method   = "Static"
  sku                 = "Standard"
}
]

bastion = {
  bastion_name        = "bastion-host"
  location            = "Southeast Asia"
  resource_group_name = "ConnectivityRG"
  subnet_id           = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/virtualNetworks/Hub-VNet/subnets/AzureBastionSubnet"
  public_ip_id        = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/publicIPAddresses/bastion-ip"
}

appgateway_config = {
  appgw_name         = "appgw"
  resource_group_name= "ConnectivityRG"
  location           = "Southeast Asia"
  sku_name           = "Standard_v2"
  sku_tier           = "Standard_v2"
  capacity           = 2
  subnet_id          = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/virtualNetworks/Hub-VNet/subnets/ApplicationGatewaySubnet"
  public_ip_id       = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/publicIPAddresses/appgateway-ip"
}

firewall_config = {
  firewall_name        = "azfw"
  location             = "Southeast Asia"
  resource_group_name  = "ConnectivityRG"
  sku_name             = "AZFW_VNet"
  sku_tier             = "Standard"
  subnet_id            = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/virtualNetworks/Hub-VNet/subnets/AzureFirewallSubnet"
  public_ip_id         = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/publicIPAddresses/firewall-ip"
}

rg_role_bindings = [
  # Platform MG
  {
    subscription_id      = "334b6757-7f3d-4d58-bdc7-416c3799808c"
    rg_name              = "ConnectivityRG"
    role_definition_name = "Network Contributor"
    principal_id         = "7ceb2d98-2482-403c-b72f-254516494870" # az-plat-net-admins
  },
  {
    subscription_id      = "334b6757-7f3d-4d58-bdc7-416c3799808c"
    rg_name              = "SecurityRG"
    role_definition_name = "Security Admin"
    principal_id         = "3f0fcc27-0721-4e09-acc8-88991da7bd44" # az-plat-sec-admins
  },
  {
    subscription_id      = "334b6757-7f3d-4d58-bdc7-416c3799808c"
    rg_name              = "IdentityRg"
    role_definition_name = "Contributor"
    principal_id         = "e3807b31-08bf-441c-812c-d698c71c8d06" # az-plat-id-admins
  },
  {
    subscription_id      = "334b6757-7f3d-4d58-bdc7-416c3799808c"
    rg_name              = "ManagementRG"
    role_definition_name = "Monitoring Contributor"
    principal_id         = "484cdb9c-7e4f-428d-bb2b-84b5b920e215" # az-plat-mgmt-admins
  }
]

subscription_id = "334b6757-7f3d-4d58-bdc7-416c3799808c"

mg_id                    = "Platform"
allowed_locations        = ["southeastasia"]
block_public_ip_resource = false   # KHÔNG cấm tạo PIP ở Platform
