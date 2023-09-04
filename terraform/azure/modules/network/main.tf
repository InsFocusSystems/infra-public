data "azurerm_resource_group" "main" {
  name = var.resourceGroup
}

resource "azurerm_virtual_network" "vnet" {
  name                = "insfocus_vnet"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "aks_subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}
