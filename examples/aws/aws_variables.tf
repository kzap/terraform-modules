variable "aws_app_servers" {
    default = "2"
    description = "The # of app servers you wish to launch"
}

variable "aws_app_image" {
    description = "Default image to use for app servers"
}

variable "aws_app_flavor" {
    description = "Default flavor to use for app servers"
}

variable "aws_db_servers" {
    default = "1"
    description = "The # of db servers you wish to launch"
}

variable "aws_db_image" {
    description = "Default image to use for db servers"
}

variable "aws_db_flavor" {
    description = "Default flavor to use for db servers"
}

# AWS Provider Defaults
variable "aws_access_key" {}

variable "aws_password" {}


variable "aws_region" {
    default = "us-west-2"
    description = "The region of AWS"
}