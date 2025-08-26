# provider "azurerm" { features {} }

########################
# Inputs
########################
variable "mg_id" {
  description = "Name của Management Group (Sandbox)"
  type        = string
  default     = "Sandbox"
}

variable "allowed_locations" {
  type    = list(string)
  default = ["southeastasia"]
}

# Sandbox: CHẶN tạo Public IP resource
variable "block_public_ip_resource" {
  type    = bool
  default = true
}

########################
# Resolve full MG resource ID
########################
data "azurerm_management_group" "this" {
  name = var.mg_id
}

########################
# 1) Allowed locations (built-in)
########################
resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  display_name         = "Allowed locations"
  management_group_id  = data.azurerm_management_group.this.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.allowed_locations }
  })
}

########################
# 2) Custom: Deny NIC có Public IP (=> VM không thể gắn PIP trực tiếp)
########################
resource "azurerm_policy_definition" "deny_nic_with_public_ip" {
  name                 = "deny-nic-with-public-ip"
  display_name         = "Deny network interfaces with Public IP"
  policy_type          = "Custom"
  mode                 = "All"
  metadata             = jsonencode({ category = "Network" })
  management_group_id  = data.azurerm_management_group.this.id

  policy_rule = jsonencode({
    "if": {
      "allOf": [
        { "field": "type", "equals": "Microsoft.Network/networkInterfaces" },
        {
          "anyOf": [
            { "field": "Microsoft.Network/networkInterfaces/ipConfigurations[*].publicIpAddress.id", "exists": true },
            { "field": "Microsoft.Network/networkInterfaces/ipConfigurations[*].publicIpAddress.id", "notEquals": "" }
          ]
        }
      ]
    },
    "then": { "effect": "Deny" }
  })
}

resource "azurerm_management_group_policy_assignment" "deny_nic_with_public_ip" {
  name                 = "deny-nic-public-ip"
  display_name         = "Deny NIC with Public IP"
  management_group_id  = data.azurerm_management_group.this.id
  policy_definition_id = azurerm_policy_definition.deny_nic_with_public_ip.id
}

########################
# 3) Custom: Deny tạo Public IP resource
########################
resource "azurerm_policy_definition" "deny_public_ip_resource" {
  count                = var.block_public_ip_resource ? 1 : 0
  name                 = "deny-public-ip-resource"
  display_name         = "Deny creating Public IP resource"
  policy_type          = "Custom"
  mode                 = "All"
  metadata             = jsonencode({ category = "Network" })
  management_group_id  = data.azurerm_management_group.this.id
  policy_rule          = jsonencode({
    "if": { "field": "type", "equals": "Microsoft.Network/publicIPAddresses" },
    "then": { "effect": "Deny" }
  })
}

resource "azurerm_management_group_policy_assignment" "deny_public_ip_resource" {
  count                = var.block_public_ip_resource ? 1 : 0
  name                 = "deny-public-ip-resource"
  display_name         = "Deny creating Public IP resource"
  management_group_id  = data.azurerm_management_group.this.id
  policy_definition_id = azurerm_policy_definition.deny_public_ip_resource[0].id
}
