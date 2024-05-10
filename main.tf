provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "foss-nsbm"

    workspaces {
      prefix = "techie-"
    }
  }
}

resource "azurerm_resource_group" "base_resource_group" {
  name     = "${var.app_name}-resource-group-${var.environment}"
  location = "eastus"

  tags = {
    Application = var.app_name
    Environment = var.environment
  }
}

# Github token for connect to the private repo
module "source_control_token" {
  source       = "./source-control-token"
  github_token = var.github_token
  depends_on   = [azurerm_resource_group.base_resource_group]
}


# Postgres database
module "postgresql" {
  source              = "./postgres"
  base_resource_group = azurerm_resource_group.base_resource_group.name
  location            = azurerm_resource_group.base_resource_group.location
  depends_on          = [azurerm_resource_group.base_resource_group]
  db_username         = var.db_username
  db_password         = var.db_password
}


# Create the web app(app service)
module "backend_app_service" {
  source = "./app-service"

  app_name            = var.app_name
  base_resource_group = azurerm_resource_group.base_resource_group.name
  location            = azurerm_resource_group.base_resource_group.location
  environment         = var.environment
  svc_name            = "backend"
  github_repo         = var.github_repo
  github_repo_branch  = var.github_repo_branch
  github_token        = var.github_token
  health_check_path   = "/api/v1/health"
  app_settings = {
    "PORT"                      = var.port
    "ENV"                       = var.environment
    "JWT_SECRET"                = var.jwt_secret
    "COURIER_API_KEY"           = var.courier_api_key
    "COURIER_EMAIL_TEMPLATE_ID" = var.courier_email_template_id
    "DB_USERNAME"               = var.db_username
    "DB_PASSWORD"               = var.db_password
    "DB_HOST"                   = var.db_host
    "DB_TABLE"                  = var.db_table
    "DB_PORT"                   = var.db_port
    "WEBSITE_RUN_FROM_PACKAGE"  = "1"
  }
  depends_on = [azurerm_resource_group.base_resource_group, module.postgresql, module.source_control_token]
}
