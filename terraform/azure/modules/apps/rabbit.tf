resource "kubernetes_deployment" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = "insfocus"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "rabbitmq"
      }
    }

    template {
      metadata {
        labels = {
          app = "rabbitmq"
        }
      }

      spec {
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }

        container {
          name  = "rabbitmq"
          image = "rabbitmq:3-management"

          env {
            name  = "RABBITMQ_DEFAULT_USER"
            value = "insfocus"
          }

          env {
            name  = "RABBITMQ_DEFAULT_PASS"
            value = "ifRabbitMQ!@#"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "512Mi"
            }

            limits = {
              cpu    = "250m"
              memory = "512Mi"
            }
          }

          port {
            container_port = 5672
            name           = "amqp"
          }

          port {
            container_port = 15672
            name           = "http"
          }

          image_pull_policy = "Always"
        }
      }
    }
  }
}

resource "kubernetes_service" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = "insfocus"
  }

  spec {
    selector = {
      app = "rabbitmq"
    }

    port {
      name       = "http"
      port       = 15672
      target_port = "http"
    }

    port {
      name       = "amqp"
      port       = 5672
      target_port = "amqp"
    }
  }
}