variable "openstack_username" {}

variable "openstack_tenant_name" {}

variable "openstack_password" {}

variable "openstack_servers" {
    default = "2"
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

variable "openstack_image" {
    description = "Default image to use"
}

variable "openstack_flavor" {
    description = "Default flavor to use"
}