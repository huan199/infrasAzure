output "virtual_network_ids" {
  description = "IDs of the created virtual networks."
  value = [for v in azurerm_virtual_network.virtual_network : v.id]
}

output "virtual_network_names" {
  description = "Names of the created virtual networks."
  value = [for v in azurerm_virtual_network.virtual_network : v.name]
}

output "subnet_ids" {
  description = "IDs of the created subnets."
  value = [for s in azurerm_subnet.network_subnets : s.id]
}

output "subnet_names" {
  description = "Names of the created subnets."
  value = [for s in azurerm_subnet.network_subnets : s.name]
}

output "network_security_group_ids" {
  description = "IDs of the created network security groups."
  value = [for n in azurerm_network_security_group.network_security_group : n.id]
}

output "network_security_group_names" {
  description = "Names of the created network security groups."
  value = [for n in azurerm_network_security_group.network_security_group : n.name]
}
