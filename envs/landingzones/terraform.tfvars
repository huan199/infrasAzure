resource_group = {
  "App01RG" = {
    location = "Southeast Asia"
  }
  "App02RG" = {
    location = "Southeast Asia"
  }
  "P1RG" = {
    location = "Southeast Asia"
  }
}

landingzones = {
  App01-VNet = {
      virtual_network_address_space = "12.0.0.0/16"
      resource_group_name = "App01RG"
      location = "Southeast Asia"
      subnets = {
        App01={
                subnet_name = "App01"
                subnet_address_prefix="12.0.0.0/24"
                network_security_group_rules=[
                {    
                  name = "App01-NSG-Rule"
                  direction = "Inbound"
                  priority = 1000        
                  destination_port_range = "*"
                  access = "Deny"
                  protocol = "Tcp"
                  source_port_range = "*"
                  source_address_prefix = "*"
                  destination_address_prefix = "*"
                },
                {
                  name = "Allow-RDP-3389"
                  direction = "Inbound"
                  priority = 200
                  access = "Allow"
                  protocol = "Tcp"
                  source_port_range = "*"
                  destination_port_range = "3389"
                  source_address_prefix = "*"
                  destination_address_prefix = "*"
                },
                {
                  name                       = "AllowPostgresOutbound"
                  direction                  = "Outbound"
                  priority                   = 210
                  access                     = "Allow"
                  protocol                   = "Tcp"
                  source_port_range          = "*"
                  destination_port_range     = "5432"
                  source_address_prefix      = "*"
                  destination_address_prefix = "0.0.0.0/0" # hoặc IP cụ thể của PostgreSQL
                }
                ]
            }
            Web01={
                subnet_name = "Web01"
                subnet_address_prefix="12.0.1.0/24"
                network_security_group_rules=[]
            }
        }
  }
        App02-VNet={
            virtual_network_address_space="12.1.0.0/16"
            resource_group_name="App02RG"
            location="Southeast Asia"
            subnets={
                  App02={
        subnet_name = "App02"
        subnet_address_prefix="12.1.0.0/24"
        network_security_group_rules=[
          {
            name = "Allow-RDP-3389"
            direction = "Inbound"
            priority = 200
            access = "Allow"
            protocol = "Tcp"
            source_port_range = "*"
            destination_port_range = "3389"
            source_address_prefix = "*"
            destination_address_prefix = "*"
          },
          {
            name                       = "AllowSqlOutbound"
            direction                  = "Outbound"
            priority                   = 220
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "1433"
            source_address_prefix      = "*"
            destination_address_prefix = "0.0.0.0/0" # hoặc IP cụ thể của Azure SQL Database
          }
        ]
      }
          Web02={
            subnet_name = "Web02"
            subnet_address_prefix="12.1.1.0/24"
            network_security_group_rules=[]
          }
        }
      }
}

storage_accounts = {
  "securitystore" = {
    location            = "Southeast Asia"
    resource_group_name = "P1RG"
    account_tier        = "Standard"
    account_replication_type = "LRS"
    account_kind        = "StorageV2"
    is_hns_enabled      = false
  }
  "dataengstore" = {
    location            = "Southeast Asia"
    resource_group_name = "P1RG"
    account_tier        = "Standard"
    account_replication_type = "LRS"
    account_kind        = "StorageV2"
    is_hns_enabled      = false
  }
}

vnet_peering_details = [
  {
    peering_name                  = "app01-to-hub"
    resource_group_name           = "App01RG"
    virtual_network_name          = "App01-VNet"
    remote_virtual_network_id     = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/virtualNetworks/Hub-VNet"
    allow_virtual_network_access  = true
    allow_forwarded_traffic       = true
    allow_gateway_transit         = false
    use_remote_gateways           = false
  },
  {
    peering_name                  = "app02-to-hub"
    resource_group_name           = "App02RG"
    virtual_network_name          = "App02-VNet"
    remote_virtual_network_id     = "/subscriptions/334b6757-7f3d-4d58-bdc7-416c3799808c/resourceGroups/ConnectivityRG/providers/Microsoft.Network/virtualNetworks/Hub-VNet"
    allow_virtual_network_access  = true
    allow_forwarded_traffic       = true
    allow_gateway_transit         = false
    use_remote_gateways           = false
  }
]

postgresql_config = [ {
  server_name             = "prod-db-app01"
  resource_group_name     = "App01RG"
  location                = "Southeast Asia"
  administrator_login     = "postgresadmin"
  administrator_password  = "P@ssw0rd123"
  sku_name                = "GP_Standard_D2ds_v4"
  version                 = "16"
  zone                    = "2"
  storage_mb              = 262144
  backup_retention_days   = 7
  public_network_access_enabled = true
  database_name           = "appdb"
  charset                 = "utf8mb4"
  collation               = "utf8mb4_general_ci"
  start_ip_address        = "0.0.0.0"
  end_ip_address          = "255.255.255.255"
} ]

sql_database_details = [
  {
    server_name            = "prod-db-app02"
    database_name          = "prod-db01"
    resource_group_name    = "App02RG"
    location               = "Southeast Asia"
    database_sku           = "GP_Gen5_4"
    administrator_login    = "sqladmin"
    administrator_password = "P@ssw0rd123"
    start_ip_address       = "0.0.0.0"
    end_ip_address         = "255.255.255.255"
  }
]

rg_role_bindings = [
  {
    subscription_id      = "5a15c534-3b59-4499-8747-f6485182b7ef"
    rg_name              = "App01RG"
    role_definition_name = "Contributor"
    principal_id         = "0a9def57-33d9-4944-8ea5-f7f5278c66c7" # az-app01-ops
  },
  {
    subscription_id      = "5a15c534-3b59-4499-8747-f6485182b7ef"
    rg_name              = "App02RG"
    role_definition_name = "Contributor"
    principal_id         = "5ee8d267-b405-4c77-bc0d-c25c68a090d4" # az-app02-ops
  },
  {
    subscription_id      = "5a15c534-3b59-4499-8747-f6485182b7ef"
    rg_name              = "P1RG"
    role_definition_name = "Contributor"
    principal_id         = "76cd5008-3a82-42d1-8a56-37aa992e695a" # az-p1-ops
  }
]

subscription_id = "5a15c534-3b59-4499-8747-f6485182b7ef"

mg_id                    = "Langind_zones"
allowed_locations        = ["southeastasia"]
block_public_ip_resource = true

