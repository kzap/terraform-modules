#OpenStack Overrides
variable "auth_url" {
    default = "https://iad2.dream.io:5000/v2.0"
}

variable "user_login" {
    default = "dhc-user"
}

variable "pub_net_id" {
    default = {
         RegionOne = "public"
         RegionOne-1 = ""
    }
}

variable "region" {
    default = "RegionOne"
    description = "The region of openstack, for image/flavor/network lookups."
}

variable "image" {
    default = {
         RegionOne = "c1e8c5b5-bea6-45e9-8202-b8e769b661a4"
         RegionOne-1 = ""
    }
}

variable "flavor" {
    default = {
         RegionOne = "200"
         RegionOne-1 = ""
    }
}