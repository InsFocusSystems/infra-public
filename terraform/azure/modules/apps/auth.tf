# Deployment for 'auth'
resource "kubernetes_deployment" "auth" {
  metadata {
    name      = "auth"
    namespace = "insfocus"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth"
        }
      }

      spec {
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }

        container {
          name  = "auth"
          image = "insfocus.azurecr.io/auth:latest"

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
            name           = "auth"
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

# Service for 'auth'
resource "kubernetes_service" "auth" {
  metadata {
    name      = "auth"
    namespace = "insfocus"
  }

  spec {
    selector = {
      app = "auth"
    }

    port {
      port        = 5000
      target_port = 5000
      name        = "auth"
    }
  }
}