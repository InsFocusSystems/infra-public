resource "kubernetes_ingress_v1" "insfocus_ingress" {
  metadata {
    name      = "insfocus-ingress"
    namespace = "insfocus"

    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"    = "false"
      "nginx.ingress.kubernetes.io/use-regex"       = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"  = "/$2"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path     = "/rabbitmq(/|$)(.*)"
          path_type = "Prefix"

          backend {
            service {
              name = "rabbitmq"
              port {
                number = 15672
              }
            }
          }
        }

        path {
          path     = "/insfocus(/|$)(.*)"
          path_type = "Prefix"

          backend {
            service {
              name = "webclient"
              port {
                number = 5000
              }
            }
          }
        }

        path {
          path     = "/auth(/|$)(.*)"
          path_type = "Prefix"

          backend {
            service {
              name = "auth"
              port {
                number = 5000
              }
            }
          }
        }

        path {
          path     = "/systemcenter(/|$)(.*)"
          path_type = "Prefix"

          backend {
            service {
              name = "systemcenter"
              port {
                number = 5000
              }
            }
          }
        }

        path {
          path     = "/dm(/|$)(.*)"
          path_type = "Prefix"

          backend {
            service {
              name = "dm"
              port {
                number = 5000
              }
            }
          }
        }

        path {
          path     = "/wf(/|$)(.*)"
          path_type = "Prefix"

          backend {
            service {
              name = "wf"
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}
