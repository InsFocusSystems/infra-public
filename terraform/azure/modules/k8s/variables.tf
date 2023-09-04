variable "environmentName" {
  description = "The name of the environment."
  type        = string
}

variable "resourceGroup" {
  description = "The resource group to use."
  type        = string
}

variable "acr_token_server" {
  description = "The ACR token server name to use for pulling images"
  type        = string
}

variable "acr_token_accesskey" {
  description = "The ACR token password to use for pulling images"
  type        = string
}

variable "acr_token_name" {
  description = "The ACR token name to use for pulling images"
  type        = string
}

variable "sqlserver_admin_password" {
  description = "The SQL Server admin password"
  type        = string
}
variable "sqlserver_url" {
  description = "The SQL Server URL"
  type        = string
}
variable "sqlserver_admin_username" {
  description = "The SQL Server admin username"
  type        = string 
}