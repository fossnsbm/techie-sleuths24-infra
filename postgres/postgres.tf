resource "azurerm_virtual_network" "base_virtual_network" {
  name                = "${var.app_name}-vnet-${var.environment}"
  location            = var.location
  resource_group_name = var.base_resource_group
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "base_subnet" {
  name                 = "${var.app_name}-subnet-${var.environment}"
  resource_group_name  = var.base_resource_group
  virtual_network_name = azurerm_virtual_network.base_virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_postgresql_flexible_server" "base_postgresql_flexible_server" {
  name                   = "${var.app_name}-psql-${var.environment}"
  resource_group_name    = var.base_resource_group
  location               = var.location
  version                = "16"
  administrator_login    = var.db_username
  administrator_password = var.db_password
  zone                   = "1"


  storage_mb   = 32768
  storage_tier = "P30"

  sku_name   = "B_Standard_B1ms"
}

resource "azurerm_postgresql_flexible_server_database" "base_postgresql_flexible_server_database" {
  name      = "${var.app_name}-psql-db-${var.environment}"
  server_id = azurerm_postgresql_flexible_server.base_postgresql_flexible_server.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_resources" {
  count     = var.public_network_access_enabled ? 1 : 0
  name      = "${var.app_name}-psql-fw-rule-azure-${var.environment}"
  server_id = azurerm_postgresql_flexible_server.base_postgresql_flexible_server.id

  # Allow connections from all Azure resources
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "all_resources" {
  count = var.public_network_access_enabled && var.firewall_allow_all_ips ? 1 : 0

  name      = "${var.app_name}-psql-fw-rule-all-${var.environment}"
  server_id = azurerm_postgresql_flexible_server.base_postgresql_flexible_server.id

  # Allow connections from all Azure resources
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
