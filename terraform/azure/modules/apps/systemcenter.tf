# Deployment for 'systemcenter'
resource "kubernetes_deployment" "systemcenter" {
  metadata {
    name      = "systemcenter"
    namespace = "insfocus"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "systemcenter"
      }
    }

    template {
      metadata {
        labels = {
          app = "systemcenter"
        }
      }

      spec {
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }

        container {
          name  = "systemcenter"
          image = "insfocus.azurecr.io/systemcenter:latest"

          env {
            name = "IF_CONFIGPROVIDER"

            value_from {
              secret_key_ref {
                name = "azure-app-config"
                key  = "value"
              }
            }
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }

            limits = {
              cpu    = "250m"
              memory = "1024Mi"
            }
          }

          port {
            container_port = 5000
            name           = "systemcenter"
          }

          image_pull_policy = "Always"
        }

        image_pull_secrets {
          name = "insfocus-acr-secret"
        }
      }
    }
  }
}

# Service for 'systemcenter'
resource "kubernetes_service" "systemcenter" {
  metadata {
    name      = "systemcenter"
    namespace = "insfocus"
  }

  spec {
    selector = {
      app = "systemcenter"
    }

    port {
      port        = 5000
      target_port = 5000
      name        = "systemcenter"
    }
  }
}