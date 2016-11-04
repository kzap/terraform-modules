output "ec2_ips" {
	value = ["${aws_instance.appserver_node.*.public_ip}"]
}

output "ec2_eips" {
	value = ["${aws_eip.appserver_eip.*.public_ip}"]
}

output "ec2_ids" {
	value = ["${aws_instance.appserver_node.*.id}"]
}
