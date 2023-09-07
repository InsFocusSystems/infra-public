output "vnet_subnet_id" {
  value = azurerm_subnet.subnet.id
  description = "The new vnet subnet ID."
  sensitive = true
}

output "public_ip_address" {
  value = azurerm_public_ip.app_ip.ip_address
}