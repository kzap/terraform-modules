# AWS
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
    # CentOS 7 AMI: https://aws.amazon.com/marketplace/pp/B00O7WM7QW
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
    default = "centos"
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
    # CentOS 7 AMI: https://aws.amazon.com/marketplace/pp/B00O7WM7QW
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


# OpenStack
variable "openstack_app_servers" {
    default = "2"
    description = "The # of app servers you wish to launch"
}

variable "openstack_app_user_login" {
    default = "root"
    description = "Default login for this image"
}

variable "openstack_app_image" {
    description = "Default image to use for app servers"
}

variable "openstack_app_flavor" {
    description = "Default flavor to use for app servers"
}

variable "openstack_db_servers" {
    default = "1"
    description = "The # of db servers you wish to launch"
}

variable "openstack_db_user_login" {
    default = "root"
    description = "Default login for this image"
}

variable "openstack_db_image" {
    description = "Default image to use for db servers"
}

variable "openstack_db_flavor" {
    description = "Default flavor to use for db servers"
}

# OpenStack Provider Defaults
variable "openstack_username" {}

variable "openstack_tenant_name" {}

variable "openstack_password" {}

variable "openstack_auth_url" {
    description = "The url to your OpenStack Provider's identity service"
}

variable "openstack_user_login" {
    default = "root"
    description = "Default login for this image"
}

variable "openstack_pub_net_id" {
    default = "public"
    description = "Network Id for the public network"
}

variable "openstack_region" {
    default = "RegionOne"
    description = "The region of openstack, for image/flavor/network lookups."
}


# Azure
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
    description = "Default login for this server"
}

variable "azure_db_servers" {
    default = 1
    description = "The # of app servers you wish to launch"
}

variable "azure_db_vm_size" {
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