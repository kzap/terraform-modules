provider "openstack" {
    user_name  = "${var.username}"
    tenant_name = "${var.tenant_name}"
    password = "${var.password}"
    auth_url  = "${var.auth_url}"
}

resource "openstack_compute_keypair_v2" "appserver_keypair" {
    name = "${var.prefix}-keypair"
    region = "${var.region}"
    public_key = "${var.public_key}"
}

/*
resource "openstack_compute_floatingip_v2" "appserver_ip" {
    region = "${var.region}"
    pool = "${var.pub_net_id}"
    count = "${var.servers}"
}
*/

resource "openstack_compute_instance_v2" "appserver_node" {
    name = "${var.prefix}-node-${count.index}"
    region = "${var.region}"
    image_id = "${var.image_id}"
    image_name = "${var.image_name}"
    flavor_id = "${var.flavor_id}"
    flavor_name = "${var.flavor_name}"
    #floating_ip = "${element(openstack_compute_floatingip_v2.appserver_ip.*.address, count.index)}"
    key_pair = "${var.prefix}-keypair"
    count = "${var.servers}"
}
