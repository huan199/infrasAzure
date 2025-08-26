output "vnet_peering_ids" {
  description = "IDs of the created virtual network peerings."
  value = [for p in azurerm_virtual_network_peering.vnet_peering : p.id]
}

output "vnet_peering_names" {
  description = "Names of the created virtual network peerings."
  value = [for p in azurerm_virtual_network_peering.vnet_peering : p.name]
}
