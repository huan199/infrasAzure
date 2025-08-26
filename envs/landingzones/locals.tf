locals {
    # Tạo danh sách các virtual network từ biến landingzones
    # Mỗi phần tử gồm tên VNet, address space, resource group và location
    virtual_network_details = flatten([
        for virtualnetwork_key, virtualnetwork in var.landingzones :
        {
            virtual_network_name           = virtualnetwork_key
            virtual_network_address_space  = virtualnetwork.virtual_network_address_space
            resource_group_name            = virtualnetwork.resource_group_name
            location                      = virtualnetwork.location
        }
    ])

    # Tạo danh sách các subnet từ tất cả các VNet trong landingzones
    # Mỗi phần tử gồm tên subnet, tên VNet, address prefix, resource group và location
    subnet_details = flatten([
        for virtualnetwork_key, virtualnetwork in var.landingzones : [
            for subnet_key, subnets in virtualnetwork.subnets :
            {
                subnet_name           = subnet_key
                virtual_network_name  = virtualnetwork_key
                subnet_address_prefix = subnets.subnet_address_prefix
                resource_group_name   = virtualnetwork.resource_group_name
                location             = virtualnetwork.location
            }
        ]
    ])

    # Tạo danh sách các network security group (NSG) cho từng subnet
    # Mỗi phần tử gồm tên VNet, tên subnet, resource group, location và các rule của NSG
    network_security_group_details = flatten([
        for virtualnetwork_key, virtualnetwork in var.landingzones : [
            for subnet_key, subnets in virtualnetwork.subnets :
            {
                virtual_network_name         = virtualnetwork_key
                subnet_name                  = subnet_key
                resource_group_name          = virtualnetwork.resource_group_name
                location                     = virtualnetwork.location
                network_security_group_rules = subnets.network_security_group_rules
            }
        ]
    ])
}