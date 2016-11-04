module "openstack_app" {
    source = "github.com/kzap/tf-lamp//providers/openstack/app-server"
    
    # Custom Config
    prefix = "${var.env}-app"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
    servers = "${var.openstack_app_servers}"
    
    # OpenStack config
    username = "${var.openstack_username}"
    tenant_name = "${var.openstack_tenant_name}"
    password = "${var.openstack_password}"
    region = "${var.openstack_region}"
    image_id = "${var.openstack_app_image}"
    flavor_id = "${var.openstack_app_flavor}"

    # OpenStack defaults
    auth_url = "${var.openstack_auth_url}"
    user_login = "${var.openstack_user_login}"
    pub_net_id = "${var.openstack_pub_net_id}"
}

module "centos_provisioner" {
    source = "github.com/kzap/tf-lamp//provisioners/bash/centos7/app-db-server"
    
    # Server Info
    servers = "${var.openstack_app_servers}"
    server_ips = ["${module.openstack_app.nodes_floating_ips}"]

    # Login Information
    user_login = "${var.openstack_user_login}"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
}