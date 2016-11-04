# Terraform Modules

Terraform modules for provisioning a CentOS 7 install on an various cloud providers.
At the moment a OpenStack & AWS provider is available with a bash provisioners for CentOS 7.

## Amazon Web Services

### Inputs

  * prefix - The prefix you want to label all your server nodes and other resources as, defaults to `apache`
  * access_key - Your AWS Access Key
  * secret_key - Your AWS Secret Key
  * key_name - The name of your AWS Keypair, you have to create this in advance
  * public_key - The contents of your public key you want to use for your key-pair
  * key_file_path - The path to your private key of the above public key which will be used to login to the servers
  * servers - The number of servers you want to spin up
  
AWS Defaults

  * region - Your AWS Region
  * azs - A list of Availability Zones you want to put your servers in
  * ami_id - The AMI of the machine you want to start with
  * instance_type - The instance type to start with
  * create_eip - If you want to attach an Elastic IP to each server (set to false for now)
  * user_login - The default user that is used on the your AMI

### Outputs

  * ec2_ips - a list of the public ips of your server nodes

### [AWS Example](./examples/aws/single-server/aws_example.tf)

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

        # Login Information
        user_login = "${var.aws_user_login}"
        public_key = "${file("${var.public_key_file}")}"
        key_file_path = "${var.private_key_file}"
    }

    output "aws_app_ips" {
        value = ["${module.aws_app.ec2_ips}"]
    }

### [AWS Variables](./examples/aws/single-server/aws.sample.tfvars)

    # Global Variables 
    public_key_file = "/path/to/public-key"
    private_key_file = "/path/to/private-key"

    # AWS Provider Variables
    aws_region = "YOUR_AWS_REGION"
    aws_access_key = "YOUR_AWS_ACCESS_KEY"
    aws_secret_key = "YOUR_AWS_SECRET_KEY"
    aws_key_name = "YOUR_AWS_KEYPAIR_NAME"

    # AWS Instance Variables
    aws_servers = 1
    aws_azs = ["LIST", "OF", "AZS"]
    aws_ami_id = "YOUR_AWS_AMI"
    aws_instance_type = "t2.micro"
    aws_create_eip = false



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

  * nodes_floating_ips - a list of the public ips of your server nodes

### [OpenStack Example](./examples/openstack/multiple-servers/openstack_example.tf)

    module "openstack_app" {
        source = "github.com/kzap/terraform-modules//providers/openstack/app-server"
        
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

    module "centos_app_provisioner" {
        source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/app-server"
        
        # Server Info
        servers = "${var.openstack_app_servers}"
        server_ips = ["${module.openstack_app.nodes_floating_ips}"]

        # Login Information
        user_login = "${var.openstack_user_login}"
        public_key = "${file("${var.public_key_file}")}"
        key_file_path = "${var.private_key_file}"
    }

    module "openstack_db" {
        source = "github.com/kzap/terraform-modules//providers/openstack/app-server"
        
        # Custom Config
        prefix = "${var.env}-db"
        public_key = "${file("${var.public_key_file}")}"
        key_file_path = "${var.private_key_file}"
        servers = "${var.openstack_db_servers}"
        
        # OpenStack config
        username = "${var.openstack_username}"
        tenant_name = "${var.openstack_tenant_name}"
        password = "${var.openstack_password}"
        region = "${var.openstack_region}"
        image_id = "${var.openstack_db_image}"
        flavor_id = "${var.openstack_db_flavor}"

        # OpenStack defaults
        auth_url = "${var.openstack_auth_url}"
        user_login = "${var.openstack_user_login}"
        pub_net_id = "${var.openstack_pub_net_id}"
    }

    module "centos_db_provisioner" {
        source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/db-server"
        
        # Server Info
        servers = "${var.openstack_db_servers}"
        server_ips = ["${module.openstack_db.nodes_floating_ips}"]

        # Login Information
        user_login = "${var.openstack_user_login}"
        public_key = "${file("${var.public_key_file}")}"
        key_file_path = "${var.private_key_file}"
    }

### [OpenStack Variables](./examples/openstack/multiple-servers/openstack.sample.tfvars)

    # Global Variables 
    public_key_file = "/path/to/public-key"
    private_key_file = "/path/to/private-key"

    # OpenStack User Variables
    openstack_username = "YOUR_OPENSTACK_USERNAME"
    openstack_tenant_name = "YOUR_OPENSTACK_TENANT_NAME"
    openstack_password = "YOUR_OPENSTACK_PASSWORD"
    openstack_region = "YOUR_OPENSTACK_REGION"
    openstack_app_servers = 2
    openstack_app_image = "YOUR_OPENSTACK_PROVIDER_IMAGE"
    openstack_app_flavor = "YOUR_OPENSTACK_PROVIDER_FLAVOR"
    openstack_db_servers = 1
    openstack_db_image = "YOUR_OPENSTACK_PROVIDER_IMAGE"
    openstack_db_flavor = "YOUR_OPENSTACK_PROVIDER_FLAVOR"

    # OpenStack Provider Variables
    openstack_user_login = "root"
    openstack_auth_url = "YOUR_OPENSTACK_PROVIDER_IDENTITY_ENDPOINT"
    openstack_pub_net_id = "public"


# LICENSE

Apache2 - See the included LICENSE file for more information.
