# Azure Provider Settings
variable "subscription_id" {
  description = "azure subscription id"
  type        = string
}

variable "client_id" {
  description = "azure application client id"
  type        = string
}

variable "client_secret" {
  description = "azure client secret"
  type        = string
}

variable "tenant_id" {
  description = "azure tenant id"
  type        = string
}

# Application Settings
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

# App Service Settings
variable "port" {
  description = "port"
  type        = number
}

variable "jwt_secret" {
  description = "jwt secret"
  type        = string
}

variable "courier_api_key" {
  description = "courier api key"
  type        = string
}

variable "courier_email_template_id" {
  description = "courier email template id"
  type        = string
}

variable "db_username" {
  description = "db username"
  type        = string
}

variable "db_password" {
  description = "db password"
  type        = string
}

variable "db_host" {
  description = "db host"
  type        = string
}

variable "db_table" {
  description = "db table"
  type        = string
}

variable "db_port" {
  description = "db port"
  type        = string
}

# Github token
variable "github_token" {
  description = "github token"
  type        = string
  sensitive   = true
}

# Github repo details
variable "github_repo" {
  description = "github repo"
  type        = string
}

variable "github_repo_branch" {
  description = "github repo"
  type        = string
}

