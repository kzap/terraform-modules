# AWS Provider Variables
variable "region" {
    default = "us-west-2"
    description = "The region of AWS"
}
variable "access_key" {}
variable "secret_key" {}

# Instance Variables
variable "ami_id" {
    default = "ami-d2c924b2"
    description = "The ID of the AMI to use"
}

variable "azs" { 
    type = "list"
    default = ["us-west-2a"]
    description = "A list of availability zones for your region that you want to put your instances on"
}

variable "subnet_id" {
    default = ""
    description = "The VPC subnet the instance(s) will go in"
}

variable "instance_type" {
    default = "t2.micro"
    description = "The instance you wish to launch"
}

variable "user_data" {
    default = ""
    description = "A string of user_data for this server"
}

variable "tags" {
    default = {
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

variable "public_key" {}

variable "key_file_path" {}

variable "create_eip" {
    default = false
    description = "Whether or not to attach an Elastic IP to this instance"
}
