output "sqlserver_admin_password" {
  value = random_password.password.result
  description = "The SQL server admin password."
  sensitive = true
}

output "sqlserver_admin_username" {
  value = azurerm_mssql_server.main.administrator_login
  description = "The SQL server admin username."
  sensitive = true
}

output "sqlserver_url" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
  description = "The SQL server access url."
}

