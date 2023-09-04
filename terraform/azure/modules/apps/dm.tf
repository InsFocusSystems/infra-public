# Deployment for 'dm'
resource "kubernetes_deployment" "dm" {
  metadata {
    name      = "dm"
    namespace = "insfocus"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "dm"
      }
    }

    template {
      metadata {
        labels = {
          app = "dm"
        }
      }

      spec {
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }

        container {
          name  = "dm"
          image = "insfocus.azurecr.io/dm:latest"

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
            name           = "dm"
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

# Service for 'dm'
resource "kubernetes_service" "dm" {
  metadata {
    name      = "dm"
    namespace = "insfocus"
  }

  spec {
    selector = {
      app = "dm"
    }

    port {
      port        = 5000
      target_port = 5000
      name        = "dm"
    }
  }
}