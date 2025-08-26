variable "subscription_id" { 
    type = string 
    description = "The ID of the Azure subscription"
}

# Gán quyền ở mức Subscription
variable "sub_role_bindings" {
  description = "List of RBAC assignments at subscription level"
  type = list(object({
    subscription_id      = string
    role_definition_name = string
    principal_id         = string
  }))
   default = []
}

# Gán quyền ở mức Resource Group
variable "rg_role_bindings" {
  description = "List of RBAC assignments at resource group level"
  type = list(object({
    subscription_id      = string
    rg_name              = string
    role_definition_name = string
    principal_id         = string
  }))
   default = []
}

