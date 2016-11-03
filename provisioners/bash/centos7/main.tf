resource "null_resource" "provision_app" {
    count = "${var.servers}"

    connection {
        host = "${var.server_ips[count.index]}"
        user = "${var.user_login}"
        private_key = "${file("${var.key_file_path}")}"
        timeout = "1m"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.servers} > /tmp/server-count",
            "echo ${count.index} > /tmp/server-index",
            "echo ${var.server_ips[count.index]} > /tmp/server-addr",
        ]
    }

    provisioner "file" {
        source = "${path.module}/files"
        destination = "/tmp/provision"
    }
  
    provisioner "remote-exec" {
        scripts = [
            "${path.module}/files/provision-centos.sh",
        ]
    }
}