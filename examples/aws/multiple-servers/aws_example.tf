module "aws_app" {
    #source = "github.com/kzap/terraform-modules//providers/aws/app-server"
    source = "../../../providers/aws/app-server"

    # Custom Config
    servers = "${var.aws_app_servers}"
    prefix = "${var.env}-app"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
    azs = "${var.aws_app_azs}"
    ami_id = "${var.aws_app_ami_id}"
    create_eip = "${var.aws_app_create_eip}"
    instance_type = "${var.aws_app_instance_type}"
    
    # AWS config
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
    key_name = "${var.aws_key_name}"
}

module "centos_app_provisioner" {
    source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/app-server"
    
    # Server Info
    servers = "${var.aws_app_servers}"
    server_ips = ["${module.aws_app.ec2_ips}"]

    # Login Information
    user_login = "${var.aws_app_user_login}"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
}

output "aws_app_ips" {
    value = ["${module.aws_app.ec2_ips}"]
}

module "aws_db" {
    #source = "github.com/kzap/terraform-modules//providers/aws/app-server"
    source = "../../../providers/aws/app-server"

    # Custom Config
    servers = "${var.aws_db_servers}"
    prefix = "${var.env}-app"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
    azs = "${var.aws_db_azs}"
    ami_id = "${var.aws_db_ami_id}"
    create_eip = "${var.aws_db_create_eip}"
    instance_type = "${var.aws_db_instance_type}"
    
    # AWS config
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
    key_name = "${var.aws_key_name}"
}

module "centos_db_provisioner" {
    source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/db-server"
    
    # Server Info
    servers = "${var.aws_db_servers}"
    server_ips = ["${module.aws_db.ec2_ips}"]

    # Login Information
    user_login = "${var.aws_db_user_login}"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
}

output "aws_db_ips" {
    value = ["${module.aws_db.ec2_ips}"]
}