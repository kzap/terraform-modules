# tf-lamp

Terraform module for provisioned CentOS 7 install on an OpenStack cloud with a LAMP stack (Linux Apache MySQL PHP)

## appserver

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

### Example

    module "app" {
      source = "github.com/kzap/tf-lamp/openstack"
      
      # Custom Config
      prefix = "app"
      public_key = "${file("~/.ssh/id_rsa.pub")}"
      key_file_path = "~/.ssh/id_rsa"
      servers = "1"

      # OpenStack config
      username = "${var.username}"
      tenant_name = "${var.tenant_name}"
      password = "${var.password}"
      region = "RegionOne"
      image_id = "c1e8c5b5-bea6-45e9-8202-b8e769b661a4"
      flavor_id = "100"

      # OpenStack defaults
      auth_url = "https://iad2.dream.io:5000/v2.0"
      user_login = "dhc-user"
      pub_net_id = "public"
    }

# LICENSE

Apache2 - See the included LICENSE file for more information.
