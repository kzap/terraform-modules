variable "aws_app_servers" {
    default = 2
    description = "The # of app servers you wish to launch"
}

variable "aws_app_azs" {
    type = "list"
    default = ["us-west-2a"]
    description = "List of AZs to use for app servers"
}

variable "aws_app_ami_id" {
    default = "ami-d2c924b2"
    description = "Default AMI to use for app servers"
}

variable "aws_app_instance_type" {
    default = "t2.micro"
    description = "Default instance type to use for app servers"
}

variable "aws_app_user_data" {
    default = ""
    description = "The contents of user_data for this server"
}

variable "aws_app_create_eip" {
    default = false
    description = "Whether or not to attach an Elastic IP to this instance"
}

variable "aws_app_user_login" {
    default = "root"
    description = "Default login for this image"
}

variable "aws_db_servers" {
    default = 1
    description = "The # of db servers you wish to launch"
}

variable "aws_db_azs" {
    type = "list"
    default = ["us-west-2a"]
    description = "List of AZs to use for db servers"
}

variable "aws_db_ami_id" {
    default = "ami-d2c924b2"
    description = "Default AMI to use for db servers"
}

variable "aws_db_instance_type" {
    default = "t2.micro"
    description = "Default instance type to use for db servers"
}

variable "aws_db_user_data" {
    default = ""
    description = "The contents of user_data for this server"
}

variable "aws_db_create_eip" {
    default = false
    description = "Whether or not to attach an Elastic IP to this instance"
}

variable "aws_db_user_login" {
    default = "root"
    description = "Default login for this image"
}

# AWS Provider Defaults
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
    default = "us-west-2"
    description = "The region of AWS"
}
