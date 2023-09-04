resource "azurerm_app_configuration" "appconf" {
  name                = "if-${var.environmentName}-config"
  resource_group_name = data.azurerm_resource_group.mainapp.name
  location            = data.azurerm_resource_group.mainapp.location
  sku                 = "standard"

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}

resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}

resource "azurerm_app_configuration_key" "configuration" {
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                    = "Configuration"
  content_type           = "application/json"
  value                  = <<EOT
  {
        "Databases" : {
            "AppDef": "Server=${var.sqlserver_url};Database=InsFocus_AppDef; User id=${var.sqlserver_admin_username};Password=${var.sqlserver_admin_password};",
            "Log": "Server=${var.sqlserver_url};Database=InsFocus_Log; User id=${var.sqlserver_admin_username};Password=${var.sqlserver_admin_password};"
        },
        "Servers" : [
            { 
                "Name" : "insfocus-main",
                "Applications" : {
                    "WebClient" : {
                        "Address": "http://webclient.insfocus"
                    },
                    "SystemCenter" : {
                        "Address": "http://systemcenter.insfocus"
                    },
                    "Workflows" : {
                        "Address": "http://wf.insfocus"
                    },
                    "DM" : {
                        "Address": "http://dm.insfocus"
                    },
                    "CMS" : {
                        "Address": "http://cms.insfocus"
                    }
                }
            }
        ],
        "PDFExporterDirectory" : "C:\\inetpub\\wwwroot\\InsFocusBIServerAgent\\ChartPDFExporter",
        "AuthServerURL": "http://auth.4dc16dd32eee4a3e934b.westeurope.aksapp.io",
        "MessageBus": {
            "Host": "rabbitmq.insfocus",
            "Username": "insfocus",
            "Password": "ifRabbitMQ!@#"
        }
}
EOT

  timeouts { 
    create = "1m"
  }

  depends_on = [
    azurerm_role_assignment.appconf_dataowner
  ]

  tags = {
    if_client_name = var.clientName
    if_environment = var.environmentName
    created_by = "InsFocus / Terraform"
  }
}