resource "azurerm_source_control_token" "base_web_app_source_control_token" {
  type         = "GitHub"
  token        = var.github_token
  token_secret = var.github_token
}
