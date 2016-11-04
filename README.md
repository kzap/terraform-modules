# tf-lamp

Terraform module for provisioning a CentOS 7 install on an OpenStack cloud with a LAMP stack (Linux Apache MySQL PHP)
At the moment a OpenStack provider is available with a bash provisioner for CentOS 7.

## OpenStack

### Inputs

  * prefix - The prefix you want to label all your server nodes and other resources as, defaults to `apache`
  * username - The username of your OpenStack API user
  * tenant_name - The tenant_name of your account
  * password - Your OpenStack API password
  * region - The region you want to use for these resources
  * public_key - The contents of your public key you want to use for your key-pair
  * key_file_path - The path to your private key of the above public key which will be used to login to the servers
  * servers - The number of servers you want to spin up
  
OpenStack Defaults

  * auth_url - The Identity Service URL of your OpenStack installation
  * user_login - The default user that is used on the your OpenStack image
  * pub_net_id - The default public network name
  * image - The image ID of the OS you want installed
  * flavor - The flavor ID of the Compute size you want

### Outputs

  * nodes_floating_ips - a comma separated list of the public ips of your server nodes

### [OpenStack Example](./examples/openstack/openstack_example.tf)

    module "openstack_app" {
      source = "github.com/kzap/tf-lamp//providers/openstack/app-server"
      
      # Custom Config
      prefix = "${var.env}-app"
      public_key = "${file("${var.public_key_file}")}"
      key_file_path = "${var.private_key_file}"
      servers = "${var.openstack_app_servers}"
      
      # OpenStack config
      username = "${var.openstack_username}"
      tenant_name = "${var.openstack_tenant_name}"
      password = "${var.openstack_password}"
      region = "${var.openstack_region}"
      image_id = "${var.openstack_app_image}"
      flavor_id = "${var.openstack_app_flavor}"

      # OpenStack defaults
      auth_url = "${var.openstack_auth_url}"
      user_login = "${var.openstack_user_login}"
      pub_net_id = "${var.openstack_pub_net_id}"
    }

    module "centos_provisioner" {
      source = "github.com/kzap/tf-lamp//provisioners/bash/centos7/app-db-server"
      
      # Server Info
      servers = "${var.openstack_app_servers}"
      server_ips = ["${module.openstack_app.nodes_floating_ips}"]

      # Login Information
      user_login = "${var.openstack_user_login}"
      public_key = "${file("${var.public_key_file}")}"
      key_file_path = "${var.private_key_file}"
    }

### [OpenStack Variables](./examples/openstack/openstack.sample.tfvars)

    # Global Variables 
    public_key_file = "/path/to/public-key"
    private_key_file = "/path/to/private-key"

    # OpenStack User Variables
    openstack_username = "YOUR_OPENSTACK_USERNAME"
    openstack_tenant_name = "YOUR_OPENSTACK_TENANT_NAME"
    openstack_password = "YOUR_OPENSTACK_PASSWORD"
    openstack_region = "YOUR_OPENSTACK_REGION"
    openstack_app_servers = 1
    openstack_app_image = "YOUR_OPENSTACK_PROVIDER_IMAGE"
    openstack_app_flavor = "YOUR_OPENSTACK_PROVIDER_FLAVOR"

    # OpenStack Provider Variables
    openstack_user_login = "root"
    openstack_auth_url = "YOUR_OPENSTACK_PROVIDER_IDENTITY_ENDPOINT"
    openstack_pub_net_id = "public"


# LICENSE

Apache2 - See the included LICENSE file for more information.
