module "azure_app" {
    #source = "github.com/kzap/terraform-modules//providers/azure/app-server"
    source = "../../../providers/azure/app-server"

    # Custom Config
    servers = "${var.azure_app_servers}"
    prefix = "${var.env}app"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
    vm_size = "${var.azure_app_vm_size}"
    user_login = "${var.azure_app_user_login}"
    
    # Azure config
    subscription_id = "${var.azure_subscription_id}"
    client_id = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
    tenant_id = "${var.azure_tenant_id}"
    location = "${var.azure_location}"
}

module "centos_app_provisioner" {
    #source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/app-server"
    source = "../../../provisioners/bash/centos-7/app-server"
    
    # Server Info
    servers = "${var.azure_app_servers}"
    server_ips = ["${module.azure_app.vm_pips}"]
    server_ids = ["${module.azure_app.vm_ids}"]

    # Login Information
    user_login = "${var.azure_app_user_login}"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
}

output "azure_app_ips" {
    value = ["${module.azure_app.vm_pips}"]
}

module "azure_db" {
    #source = "github.com/kzap/terraform-modules//providers/azure/app-server"
    source = "../../../providers/azure/app-server"

    # Custom Config
    servers = "${var.azure_db_servers}"
    prefix = "${var.env}db"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
    vm_size = "${var.azure_db_vm_size}"
    user_login = "${var.azure_db_user_login}"
    
    # Azure config
    subscription_id = "${var.azure_subscription_id}"
    client_id = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
    tenant_id = "${var.azure_tenant_id}"
    location = "${var.azure_location}"
}

module "centos_db_provisioner" {
    #source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/db-server"
    source = "../../../provisioners/bash/centos-7/db-server"
    
    # Server Info
    servers = "${var.azure_db_servers}"
    server_ips = ["${module.azure_db.vm_pips}"]
    server_ids = ["${module.azure_db.vm_ids}"]

    # Login Information
    user_login = "${var.azure_db_user_login}"
    public_key = "${file("${var.public_key_file}")}"
    key_file_path = "${var.private_key_file}"
}

output "azure_db_ips" {
    value = ["${module.azure_db.vm_pips}"]
}