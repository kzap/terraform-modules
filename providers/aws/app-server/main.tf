provider "aws" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

resource "aws_instance" "appserver_node" {
    ami = "${var.ami_id}"
    availability_zone = "${element(var.azs, count.index)}"
    key_name = "${var.key_name}"
    instance_type = "${var.instance_type}"
    user_data = "${var.user_data}"

    tags {
        Name = "${var.prefix}-node-${count.index}"
        created_by = "${lookup(var.tags,"created_by")}"
    }

    root_block_device {
        delete_on_termination = true
    }

    count = "${var.servers}"
}

resource "aws_eip" "appserver_eip" {
    count = "${replace(var.create_eip, "1", var.servers)}"
    instance = "${element(aws_instance.appserver_node.*.id, count.index)}"
}