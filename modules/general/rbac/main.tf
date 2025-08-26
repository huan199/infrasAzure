# Gán quyền ở mức Subscription cho nhiều subscription
resource "azurerm_role_assignment" "sub" {
  for_each = {
    for idx, b in var.sub_role_bindings : "${b.subscription_id}-${b.role_definition_name}-${b.principal_id}" => b
  }
  scope                = "/subscriptions/${each.value.subscription_id}"
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

# Gán quyền ở mức Resource Group cho nhiều subscription và resource group
resource "azurerm_role_assignment" "rg" {
  for_each = {
    for idx, b in var.rg_role_bindings : "${b.subscription_id}-${b.rg_name}-${b.role_definition_name}-${b.principal_id}" => b
  }
  scope                = "/subscriptions/${each.value.subscription_id}/resourceGroups/${each.value.rg_name}"
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
