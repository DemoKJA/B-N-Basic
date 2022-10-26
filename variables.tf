# Variable definitions and default values

variable "location" {
  type    = string
  default = "eastus 2"
}

variable "adf_git" {}
variable "environment" {}

variable "tags" {
  type = map(string)
}

variable "ClientContainerName" {
  type = list(string)
}