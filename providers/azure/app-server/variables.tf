# Azure Provider Variables
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "location" {
    default = "West US"
}

# Instance Variables
variable "tags" {
    default = {
        environment = "staging"
        created_by = "terraform"
    }
}

variable "prefix" {
    default = "apache"
}

variable "servers" {
    default = 1
    description = "The number of App servers to launch."
}

variable "vm_size" {
    default = "Standard_A0"
    description = "Size of the VM. See https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/"
}

variable "user_login" {
    default = "centos"
    description = "Default login for this image"
}

variable "user_password" {
    default = "Password1234!"
    description = "Default password for this image"
}

# Images to use
# See https://github.com/Azure/azure-quickstart-templates/blob/master/101-vm-simple-windows/azuredeploy.json
variable "image_publisher" {
    default = "OpenLogic"
    description = "OS Image Publisher"
}

variable "image_offer" {
    default = "CentOS"
    description = "OS Image Offer"
}

variable "image_sku" {
    default = "7.2"
    description = "OS Image SKU"
}

variable "image_version" {
   default = "latest"
   description = "OS Image Version"
}

variable "public_key" {}

variable "key_file_path" {}