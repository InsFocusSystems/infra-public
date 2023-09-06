resource "azurerm_kubernetes_cluster" "mainapp" {
  name                = "insfocus"
  location            = data.azurerm_resource_group.mainapp.location
  resource_group_name = data.azurerm_resource_group.mainapp.name
  dns_prefix          = "k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = var.vnet_subnet_id

    tags = {
      if_client_name = var.clientName
      if_environment = var.environmentName
      created_by = "InsFocus / Terraform"
    }
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    service_cidr = "10.0.16.0/20"
    dns_service_ip = "10.0.16.10"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.mainapp.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.mainapp.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.mainapp.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.mainapp.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.mainapp.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.mainapp.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.mainapp.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.mainapp.kube_config.0.cluster_ca_certificate)
  }
}

# Create namespaces
resource "kubernetes_namespace" "insfocus" {
  metadata {
    name = "insfocus"
  }
}
resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress-nginx"
  }
}

# Create secrets
resource "kubernetes_secret" "acr_auth" {
  metadata {
    name      = "insfocus-acr-secret"
    namespace = "insfocus"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      "auths" = {
        "${var.acr_token_server}" = {
          "username" = var.acr_token_name
          "password" = var.acr_token_accesskey
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "azure-app-config" {
  metadata {
    name      = "azure-app-config"
    namespace = "insfocus"
  }

  data = {
    value = azurerm_app_configuration.appconf.primary_read_key[0].connection_string
  }

  type = "Opaque"

  depends_on = [
    azurerm_app_configuration_key.configuration
  ]
}

# Deploy nginx controller
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.replicaCount"
    value = "1"
    type  = "string"
  }
  set {
    name  = "controller.nodeSelector\\.beta\\.kubernetes\\.io/os"
    value = "linux"
    type  = "string"
  }
  set {
    name  = "defaultBackend.nodeSelector\\.beta\\.kubernetes\\.io/os"
    value = "linux"
    type  = "string"
  }
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
    type  = "string"
  }
}
