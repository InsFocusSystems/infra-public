# Deployment for 'webclient'
resource "kubernetes_deployment" "webclient" {
  metadata {
    name      = "webclient"
    namespace = "insfocus"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "webclient"
      }
    }

    template {
      metadata {
        labels = {
          app = "webclient"
        }
      }

      spec {
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }

        container {
          name  = "webclient"
          image = "insfocus.azurecr.io/webclient:latest"

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
            name           = "webclient"
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

# Service for 'webclient'
resource "kubernetes_service" "webclient" {
  metadata {
    name      = "webclient"
    namespace = "insfocus"
  }

  spec {
    selector = {
      app = "webclient"
    }

    port {
      port        = 5000
      target_port = 5000
      name        = "webclient"
    }
  }
}