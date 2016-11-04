provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"
}

resource "azurerm_resource_group" "appserver_rg" {
    count = "${signum(var.servers)}"
    name = "${var.prefix}-${md5("${var.prefix}")}-rg"
    location = "${var.location}"
}

resource "azurerm_virtual_network" "appserver_vnet" {
    count = "${signum(var.servers)}"
    name = "${var.prefix}-${md5("${var.prefix}")}-vnet"
    address_space = ["10.0.0.0/16"]
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.appserver_rg.name}"
}

resource "azurerm_subnet" "appserver_snet" {
    count = "${signum(var.servers)}"
    name = "${var.prefix}-${md5("${var.prefix}")}-snet"
    resource_group_name = "${azurerm_resource_group.appserver_rg.name}"
    virtual_network_name = "${azurerm_virtual_network.appserver_vnet.name}"
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_network_interface" "appserver_nic" {
    count = "${var.servers}"
    name = "${var.prefix}-${md5("${var.prefix}")}-nic-${count.index}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.appserver_rg.name}"

    ip_configuration {
        name = "${var.prefix}-configuration"
        subnet_id = "${azurerm_subnet.appserver_snet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${element(azurerm_public_ip.appserver_pip.*.id, count.index)}"
    }
}

resource "azurerm_public_ip" "appserver_pip" {
    count = "${var.servers}"
    name = "${var.prefix}-${md5("${var.prefix}")}-pip-${count.index}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.appserver_rg.name}"
    public_ip_address_allocation = "static"

    tags {
        environment = "${lookup(var.tags,"environment")}"
        created_by = "${lookup(var.tags,"created_by")}"
    }
}

resource "azurerm_storage_account" "appserver_sa" {
    count = "${var.servers}"
    name = "${var.prefix}Storage${count.index}"
    resource_group_name = "${azurerm_resource_group.appserver_rg.name}"
    location = "${var.location}"
    account_type = "Standard_LRS"

    tags {
        environment = "${lookup(var.tags,"environment")}"
        created_by = "${lookup(var.tags,"created_by")}"
    }
}

resource "azurerm_storage_container" "appserver_vhds" {
    count = "${var.servers}"
    name = "${var.prefix}-${md5("${var.prefix}")}-vhds"
    resource_group_name = "${azurerm_resource_group.appserver_rg.name}"
    storage_account_name = "${element(azurerm_storage_account.appserver_sa.*.name, count.index)}"
    container_access_type = "private"
}

resource "azurerm_virtual_machine" "appserver_vm" {
    count = "${var.servers}"
    name = "${var.prefix}-${md5("${var.prefix}")}-vm-${count.index}"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.appserver_rg.name}"
    network_interface_ids = ["${element(azurerm_network_interface.appserver_nic.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_image_reference {
        publisher = "${var.image_publisher}"
        offer = "${var.image_offer}"
        sku = "${var.image_sku}"
        version = "${var.image_version}"
    }

    storage_os_disk {
        name = "myosdisk1"
        vhd_uri = "${element(azurerm_storage_account.appserver_sa.*.primary_blob_endpoint, count.index)}${element(azurerm_storage_container.appserver_vhds.*.name, count.index)}/myosdisk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.prefix}-vm"
        admin_username = "${var.user_login}"
        admin_password = "${var.user_password}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path = "/home/${var.user_login}/.ssh/authorized_keys"
            key_data = "${var.public_key}"
        }
    }

    tags {
        environment = "${lookup(var.tags,"environment")}"
        created_by = "${lookup(var.tags,"created_by")}"
    }
}