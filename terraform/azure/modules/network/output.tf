output "vnet_subnet_id" {
  value = azurerm_subnet.subnet.id
  description = "The new vnet subnet ID."
  sensitive = true
}