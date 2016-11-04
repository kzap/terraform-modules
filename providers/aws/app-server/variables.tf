# AWS credentials
variable "region" {
    default = "us-west-2"
    description = "The region of AWS"
}
variable "az" { 
    default = "us-west-2a"
}
variable "access_key" {}
variable "secret_key" {}

variable "ami_id" {}
variable "vpc_cidr" {}
variable "subnet_id" {}

variable "public_key" {}
variable "key_file_path" {}

variable "user_login" {
    default = "root"
}

variable "prefix" {
    default = "apache"
}

variable "servers" {
    default = "2"
    description = "The number of App servers to launch."
}
