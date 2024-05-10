variable "app_name" {
  description = "app name"
  type        = string
}

variable "base_resource_group" {
  description = "base resource group"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "environment" {
  description = "applicaiton environment"
  type        = string
}

variable "svc_name" {
  description = "service name"
  type        = string
}

variable "github_repo" {
  description = "github repo"
  type        = string
}

variable "github_repo_branch" {
  description = "github repo branch"
  type        = string
}

variable "github_token" {
  description = "github token"
  type        = string
}

variable "health_check_path" {
  description = "health check path"
  type        = string
}

variable "app_settings" {
  description = "App settings for the app service"
  type        = map(string)
  default     = {}
}
