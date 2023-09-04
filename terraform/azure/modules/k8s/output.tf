output "appConfig_ConnectionString" {
  value = azurerm_app_configuration.appconf.primary_read_key[0].connection_string
  description = "The connection string to the app configuration."
  sensitive = true
}

output "kubernetes_info" {
  value = azurerm_kubernetes_cluster.mainapp.kube_config.0
  description = "The kubernetes configuration block."
  sensitive = true
}