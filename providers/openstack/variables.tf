variable "username" {}
variable "password" {}
variable "tenant_name" {}
variable "auth_url" {}
variable "public_key" {}
variable "user_login" {
    default = "stack"
}
variable "key_file_path" {}

variable "prefix" {
    default = "apache"
}

variable "pub_net_id" {
    default = "PublicNetwork-01"
}

variable "region" {
    default = "tr2"
    description = "The region of openstack, for image/flavor/network lookups."
}

variable "image_id" {
    default = "eee08821-c95a-448f-9292-73908c794661"
}

variable "image_name" {
    default = ""
}

variable "flavor_id" {
    default = "200"
}

variable "flavor_name" {
    default = ""
}

variable "servers" {
    default = "2"
    description = "The number of App servers to launch."
}
