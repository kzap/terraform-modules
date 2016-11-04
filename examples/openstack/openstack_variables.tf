variable "openstack_username" {}

variable "openstack_tenant_name" {}

variable "openstack_password" {}

variable "openstack_app_servers" {
    default = "2"
    description = "The # of app servers you wish to launch"
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

variable "openstack_db_image" {
    description = "Default image to use for db servers"
}

variable "openstack_db_flavor" {
    description = "Default flavor to use for db servers"
}

# OpenStack Provider Defaults
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