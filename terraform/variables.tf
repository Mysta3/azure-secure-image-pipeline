# file used to create variables that can be used throughout the codebase.
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "staging_resource_group_name" {
  description = "Name of the staging Resource Group used by Azure Image Builder"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}