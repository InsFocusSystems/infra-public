data "azurerm_resource_group" "mainapp" {
  name = var.resourceGroup
}

resource "azurerm_virtual_network" "vnet" {
  name                = "insfocus_vnet"
  location            = data.azurerm_resource_group.mainapp.location
  resource_group_name = data.azurerm_resource_group.mainapp.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "aks_subnet"
  resource_group_name  = data.azurerm_resource_group.mainapp.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.8.0/24"]
}

resource "azurerm_public_ip" "app_ip" {
  name                = "k8s-ip"
  location            = data.azurerm_resource_group.mainapp.location
  resource_group_name = data.azurerm_resource_group.mainapp.name
  allocation_method   = "Static"
  sku                 = "Standard"
}