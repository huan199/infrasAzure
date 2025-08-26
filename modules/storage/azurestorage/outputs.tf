output "storage_account_ids" {
  description = "IDs of the created storage accounts."
  value = { for sa in azurerm_storage_account.storage_account : sa.name => sa.id }
}

output "storage_account_names" {
  description = "Names of the created storage accounts."
  value = [for sa in azurerm_storage_account.storage_account : sa.name]
}
