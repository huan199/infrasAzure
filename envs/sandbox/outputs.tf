output "resource_group_ids" {
  description = "IDs of the created resource groups."
  value = module.resource_group.resource_group_ids
}

output "resource_group_names" {
  description = "Names of the created resource groups."
  value = module.resource_group.resource_group_names
}

output "virtual_network_ids" {
  description = "IDs of the created virtual networks."
  value = module.network.virtual_network_ids
}

output "subnet_ids" {
  description = "IDs of the created subnets."
  value = module.network.subnet_ids
}

output "network_security_group_ids" {
  description = "IDs of the created network security groups."
  value = module.network.network_security_group_ids
}
