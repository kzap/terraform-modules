variable "azure_app_servers" {
    default = 2
    description = "The # of app servers you wish to launch"
}

variable "azure_app_vm_size" {
    default = "Standard_A0"
    description = "Size of the VM. See https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/"
}

variable "azure_app_user_login" {
    default = "centos"
    description = "Default login for this image"
}

variable "azure_db_servers" {
    default = 1
    description = "The # of app servers you wish to launch"
}

variable "azure_app_db_size" {
    default = "Standard_A0"
    description = "Size of the VM. See https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/"
}

variable "azure_db_user_login" {
    default = "centos"
    description = "Default login for this image"
}

# Azure Provider Defaults
variable "azure_subscription_id" {}
variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}
variable "azure_location" {
    default = "West US"
}
