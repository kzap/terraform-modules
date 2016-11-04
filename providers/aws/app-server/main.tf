provider "aws" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

resource "aws_instance" "appserver_node" {
    ami = "${var.ami_id}"
    subnet_id = "${var.subnet_id}"
}

resource "openstack_compute_keypair_v2" "appserver_keypair" {
    name = "${var.prefix}-keypair"
    region = "${var.region}"
    public_key = "${var.public_key}"
}

resource "openstack_compute_instance_v2" "appserver_node" {
  name = "${var.prefix}-node-${count.index}"
  region = "${var.region}"
  image_id = "${var.image_id}"
  image_name = "${var.image_name}"
  flavor_id = "${var.flavor_id}"
  flavor_name = "${var.flavor_name}"
  #floating_ip = "${element(openstack_compute_floatingip_v2.appserver_ip.*.address,count.index)}"
  key_pair = "${var.prefix}-keypair"
  count = "${var.servers}"
}
