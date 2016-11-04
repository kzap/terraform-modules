variable "aws_servers" {
    default = 2
    description = "The # of app servers you wish to launch"
}

variable "aws_azs" {
    type = "list"
    default = ["us-west-2a"]
    description = "List of AZs to use for app servers"
}

variable "aws_ami_id" {
    # CentOS 7 AMI: https://aws.amazon.com/marketplace/pp/B00O7WM7QW
    default = "ami-d2c924b2"
    description = "Default AMI to use for app servers"
}

variable "aws_instance_type" {
    default = "t2.micro"
    description = "Default instance type to use for app servers"
}

variable "aws_user_data" {
    default = ""
    description = "The contents of user_data for this server"
}

variable "aws_create_eip" {
    default = false
    description = "Whether or not to attach an Elastic IP to this instance"
}

variable "aws_user_login" {
    default = "centos"
    description = "Default login for this image"
}

# AWS Provider Defaults
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
    default = "us-west-2"
    description = "The region of AWS"
}

variable "aws_key_name" {
    description = "The AWS keypair name of the public key you wish to use"
}
