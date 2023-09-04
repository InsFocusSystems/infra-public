# Deployment for 'wf'
resource "kubernetes_deployment" "wf" {
  metadata {
    name      = "wf"
    namespace = "insfocus"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wf"
      }
    }

    template {
      metadata {
        labels = {
          app = "wf"
        }
      }

      spec {
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }

        container {
          name  = "wf"
          image = "insfocus.azurecr.io/wf:latest"

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
            name           = "wf"
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

# Service for 'wf'
resource "kubernetes_service" "wf" {
  metadata {
    name      = "wf"
    namespace = "insfocus"
  }

  spec {
    selector = {
      app = "wf"
    }

    port {
      port        = 5000
      target_port = 5000
      name        = "wf"
    }
  }
}