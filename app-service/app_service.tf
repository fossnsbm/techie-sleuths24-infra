
resource "azurerm_service_plan" "base_service_plan" {
  name                = "${var.app_name}-${var.svc_name}-plan-${var.environment}"
  location            = var.location
  resource_group_name = var.base_resource_group
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    Application = "${var.app_name}-${var.svc_name}"
    Environment = var.environment
  }
}

resource "azurerm_linux_web_app" "base_web_app" {
  name                = "${var.app_name}-${var.svc_name}-webapp-${var.environment}"
  location            = var.location
  resource_group_name = var.base_resource_group
  service_plan_id     = azurerm_service_plan.base_service_plan.id
  https_only          = true


  identity {
    type = "SystemAssigned"
  }

  app_settings = var.app_settings

  site_config {
    health_check_path = var.health_check_path

    application_stack {
      go_version = "1.19"
    }
  }

  tags = {
    Application = "${var.app_name}-${var.svc_name}"
    Environment = var.environment
  }
}

resource "azurerm_app_service_source_control" "base_web_app_source_control" {
  app_id                 = azurerm_linux_web_app.base_web_app.id
  repo_url               = var.github_repo
  branch                 = var.github_repo_branch
  use_manual_integration = true
  depends_on             = [var.github_token]
}
