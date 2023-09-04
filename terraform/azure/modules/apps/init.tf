data "azurerm_resource_group" "mainapp" {
  name = var.resourceGroup
}

data "azurerm_kubernetes_cluster" "mainapp" {
  name                = "insfocus"
  resource_group_name = data.azurerm_resource_group.mainapp.name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.mainapp.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.mainapp.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.mainapp.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.mainapp.kube_config.0.cluster_ca_certificate)
}