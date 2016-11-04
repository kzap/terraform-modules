module "azure_app" {
    #source = "github.com/kzap/terraform-modules//providers/azure/app-server"
    source = "../../../providers/azure/app-server"

    # Custom Config
    servers = "${var.azure_servers}"
    prefix = "${var.env}app"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
    vm_size = "${var.azure_vm_size}"
    user_login = "${var.azure_user_login}"
    
    # Azure config
    subscription_id = "${var.azure_subscription_id}"
    client_id = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
    tenant_id = "${var.azure_tenant_id}"
    location = "${var.azure_location}"
}

module "centos_app_provisioner" {
    #source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/app-db-server"
    source = "../../../provisioners/bash/centos-7/app-db-server"
    
    # Server Info
    servers = "${var.azure_servers}"
    server_ips = ["${module.azure_app.vm_pips}"]
    server_ids = ["${module.azure_app.vm_ids}"]

    # Login Information
    user_login = "${var.azure_user_login}"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
}

output "azure_app_ips" {
    value = ["${module.azure_app.vm_pips}"]
}