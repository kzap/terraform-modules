module "openstack_app" {
    source = "openstack"
    
    # Custom Config
    prefix = "${var.env}-app"
    public_key = "${file("${var.public_key_file}")}"
	key_file_path = "${var.private_key_file}"
    servers = "${var.app_servers}"
    
    # OpenStack config
    username = "${var.username}"
    tenant_name = "${var.tenant_name}"
    password = "${var.password}"
    region = "${var.region}"
    image_id = "${var.app_image}"
    flavor_id = "${var.app_flavor}"

    # OpenStack defaults
    auth_url = "${var.auth_url}"
    user_login = "${var.user_login}"
    pub_net_id = "${var.pub_net_id}"
}