resource "random_integer" "log_analytics_suffix" {
  min = 1000
  max = 9999
}

# Thêm tài nguyên cho không gian làm việc phân tích nhật ký
resource "azurerm_log_analytics_workspace" "workspace" {
  for_each = var.log_analytics_workspaces
  name = "${each.key}-${random_integer.log_analytics_suffix.result}"
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  sku = "PerGB2018"
  retention_in_days = "30"
}