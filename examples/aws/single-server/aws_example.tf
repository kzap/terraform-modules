module "aws_app" {
    source = "github.com/kzap/terraform-modules//providers/aws/app-server"

    # Custom Config
    servers = "${var.aws_servers}"
    prefix = "${var.env}-app"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
    azs = "${var.aws_azs}"
    ami_id = "${var.aws_ami_id}"
    create_eip = "${var.aws_create_eip}"
    instance_type = "${var.aws_instance_type}"
    
    # AWS config
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
    key_name = "${var.aws_key_name}"   
}

module "centos_app_provisioner" {
    source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/app-db-server"
    
    # Server Info
    servers = "${var.aws_servers}"
    server_ips = ["${module.aws_app.ec2_ips}"]
    server_ids = ["${module.aws_app.ec2_ids}"]

    # Login Information
    user_login = "${var.aws_user_login}"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
}

output "aws_app_ips" {
    value = ["${module.aws_app.ec2_ips}"]
}