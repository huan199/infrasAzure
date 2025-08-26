variable "resource_group" {
  type = map(object({
    location = string
  }))
}