resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mssql_server" "main" {
  name                         = "if-${var.clientName}-sql"
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "insfocus"
  administrator_login_password = random_password.password.result

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}

resource "azurerm_mssql_database" "appdef" {
  name                = "InsFocus_AppDef"
  server_id         = azurerm_mssql_server.main.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  
  auto_pause_delay_in_minutes = 60
  max_size_gb                 = 32
  min_capacity                = 0.5
  read_replica_count          = 0
  read_scale                  = false
  sku_name                    = "GP_S_Gen5_1"
  zone_redundant              = false

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}

resource "azurerm_mssql_database" "qbdef" {
  name                = "InsFocus_QBDef"
  server_id         = azurerm_mssql_server.main.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  
  auto_pause_delay_in_minutes = 60
  max_size_gb                 = 32
  min_capacity                = 0.5
  read_replica_count          = 0
  read_scale                  = false
  sku_name                    = "GP_S_Gen5_1"
  zone_redundant              = false

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}

resource "azurerm_mssql_database" "log" {
  name                = "InsFocus_Log"
  server_id         = azurerm_mssql_server.main.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  
  auto_pause_delay_in_minutes = 60
  max_size_gb                 = 32
  min_capacity                = 0.5
  read_replica_count          = 0
  read_scale                  = false
  sku_name                    = "GP_S_Gen5_1"
  zone_redundant              = false

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}
