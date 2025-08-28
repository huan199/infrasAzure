resource_group = {
  "SandboxRG" = {
    location = "Southeast Asia"
  }
  "AppTest" = {
    location = "Southeast Asia"
  }
}

sandbox = {
  AppTest-VNet = {
      virtual_network_address_space = "14.0.0.0/16"
      resource_group_name = "AppTest"
      location = "Southeast Asia"
      subnets = {
        App={
          subnet_name = "AppTest"
                subnet_address_prefix="14.0.0.0/24"
                network_security_group_rules=[
                {
                  name = "AppTestInbound"
                  direction = "Inbound"
                  priority = 300
                  access = "Allow"
                  protocol = "Tcp"
                  source_port_range = "3389"
                  destination_port_range = "*"
                  source_address_prefix = "*"
                  destination_address_prefix = "*"
                }
                ]
            }
            Web={
              subnet_name = "WebTest"
                subnet_address_prefix="14.0.1.0/24"
                network_security_group_rules=[]
            }
        }
  }
}

vnet_peering_details = [
  {
    peering_name                  = "apptest-to-hub"
    resource_group_name           = "AppTest"
    virtual_network_name          = "AppTest-VNet"
    remote_virtual_network_id     = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/virtualNetworks/Hub-VNet"
    allow_virtual_network_access  = true
    allow_forwarded_traffic       = true
    allow_gateway_transit         = false
    use_remote_gateways           = false
  }
]

rg_role_bindings = [
  {
    subscription_id      = "57388369-0905-4b81-9ea7-a7ae033d3bff"
    rg_name              = "SandboxRG"
    role_definition_name = "Contributor"
    principal_id         = "7c12719e-b720-4041-8572-6e4eedc4b8ee" # ObjectId az-sandbox-users
  },
  {
    subscription_id      = "57388369-0905-4b81-9ea7-a7ae033d3bff"
    rg_name              = "SandboxRG"
    role_definition_name = "Reader"
    principal_id         = "1892c777-9562-4968-8480-2bf428e1370b" # ObjectId az-sandbox-audit
  }
]

subscription_id = "57388369-0905-4b81-9ea7-a7ae033d3bff"

mg_id                    = "Sandbox"
allowed_locations        = ["southeastasia"]
block_public_ip_resource = true    # CẤM tạo PIP ở Sandbox

app_config = {
	resource_group_name = "SandboxRG"
	location            = "southeastasia"
	webapp_name         = "webapp7785534"
	service_details     = ["serviceplan500090", "F1", "Windows"]
}