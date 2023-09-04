variable "resourceGroup" {
  description = "The resource group to use."
  type        = string
}

variable "environmentName" {
  description = "The name of the environment."
  type        = string
}

variable "appConfig_ConnectionString" {
  type        = string
}