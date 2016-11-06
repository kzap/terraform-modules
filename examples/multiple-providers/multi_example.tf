module "aws_multi" {
    source = "github.com/kzap/terraform-modules//examples/aws/multiple-servers/"

    # Custom Config
    env = "${var.env}"
    public_key_file = "${var.public_key_file}"
    private_key_file = "${var.private_key_file}"

    aws_app_servers = "${var.aws_app_servers}"
    aws_app_azs = "${var.aws_app_azs}"
    aws_app_ami_id = "${var.aws_app_ami_id}"
    aws_app_instance_type = "${var.aws_app_instance_type}"
    
    aws_db_servers = "${var.aws_db_servers}"
    aws_db_azs = "${var.aws_db_azs}"
    aws_db_ami_id = "${var.aws_db_ami_id}"
    aws_db_instance_type = "${var.aws_db_instance_type}"
    
    # AWS config
    aws_access_key = "${var.aws_access_key}"
    aws_secret_key = "${var.aws_secret_key}"
    aws_region = "${var.aws_region}"
    aws_key_name = "${var.aws_key_name}"
}

output "aws_app_ips" {
    value = ["${concat(module.aws_multi.aws_app_ips, module.aws_multi.aws_db_ips)}"]
}

module "openstack_multi" {
    source = "github.com/kzap/terraform-modules//examples/openstack/multiple-servers/"
    
    # Custom Config
    env = "${var.env}"
    public_key_file = "${var.public_key_file}"
    private_key_file = "${var.private_key_file}"

    openstack_app_servers = "${var.openstack_app_servers}"
    openstack_app_user_login = "${var.openstack_app_user_login}"
    openstack_app_image = "${var.openstack_app_image}"
    openstack_app_flavor = "${var.openstack_app_flavor}"

    openstack_db_servers = "${var.openstack_db_servers}"
    openstack_db_user_login = "${var.openstack_db_user_login}"
    openstack_db_image = "${var.openstack_db_image}"
    openstack_db_flavor = "${var.openstack_db_flavor}"

    # OpenStack config
    openstack_username = "${var.openstack_username}"
    openstack_tenant_name = "${var.openstack_tenant_name}"
    openstack_password = "${var.openstack_password}"
    openstack_region = "${var.openstack_region}"
    openstack_auth_url = "${var.openstack_auth_url}"
    openstack_pub_net_id = "${var.openstack_pub_net_id}"
}

output "openstack_app_ips" {
    value = ["${concat(module.openstack_multi.openstack_app_ips, module.openstack_multi.openstack_db_ips)}"]
}

module "azure_multi" {
    source = "github.com/kzap/terraform-modules//examples/azure/multiple-servers/"

    # Custom Config
    env = "${var.env}"
    public_key_file = "${var.public_key_file}"
    private_key_file = "${var.private_key_file}"

    azure_app_servers = "${var.azure_app_servers}"
    azure_app_vm_size = "${var.azure_app_vm_size}"
    azure_app_user_login = "${var.azure_app_user_login}"

    azure_db_servers = "${var.azure_db_servers}"
    azure_db_vm_size = "${var.azure_db_vm_size}"
    azure_db_user_login = "${var.azure_db_user_login}"
    
    # Azure config
    azure_subscription_id = "${var.azure_subscription_id}"
    azure_client_id = "${var.azure_client_id}"
    azure_client_secret = "${var.azure_client_secret}"
    azure_tenant_id = "${var.azure_tenant_id}"
    azure_location = "${var.azure_location}"
}

output "azure_app_ips" {
    value = ["${concat(module.azure_multi.azure_app_ips, module.azure_multi.azure_db_ips)}"]
}