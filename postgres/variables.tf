variable "base_resource_group" {
  description = "base resource group"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "app_name" {
  description = "application name"
  type        = string
  default     = "techiesleuths"
}

variable "environment" {
  description = "Applicaiton environment"
  type        = string
  default     = "prod"
}

variable "db_username" {
  description = "postgres admin username"
  type        = string
}

variable "db_password" {
  description = "postgres admin password"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "firewall_allow_all_ips" {
  description = "Allow all IPs"
  type        = bool
  default     = true
}
