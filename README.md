# Terraform Modules

Terraform modules for provisioning a CentOS 7 install on an various cloud providers.
At the moment a AWS, OpenStack & Azure provider is available with a bash provisioners for CentOS 7.
An example is also provided for launching multiple providers via one configuration using modules.

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
  * user_login - The default user that is used on the your OpenStack image
  
OpenStack Defaults

  * auth_url - The Identity Service URL of your OpenStack installation
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
        user_login = "${var.openstack_app_user_login}"
        image_id = "${var.openstack_app_image}"
        flavor_id = "${var.openstack_app_flavor}"
        
        # OpenStack config
        username = "${var.openstack_username}"
        tenant_name = "${var.openstack_tenant_name}"
        password = "${var.openstack_password}"
        region = "${var.openstack_region}"
        auth_url = "${var.openstack_auth_url}"
        pub_net_id = "${var.openstack_pub_net_id}"
    }

    module "centos_app_provisioner" {
        source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/app-server"
        
        # Server Info
        servers = "${var.openstack_app_servers}"
        server_ips = ["${module.openstack_app.nodes_floating_ips}"]

        # Login Information
        user_login = "${var.openstack_app_user_login}"
        public_key = "${file("${var.public_key_file}")}"
        key_file_path = "${var.private_key_file}"
    }

    output "openstack_app_ips" {
        value = ["${module.openstack_app.nodes_floating_ips}"]
    }

    module "openstack_db" {
        source = "github.com/kzap/terraform-modules//providers/openstack/app-server"
        
        # Custom Config
        prefix = "${var.env}-db"
        public_key = "${file("${var.public_key_file}")}"
        key_file_path = "${var.private_key_file}"

        servers = "${var.openstack_db_servers}"
        user_login = "${var.openstack_db_user_login}"
        image_id = "${var.openstack_db_image}"
        flavor_id = "${var.openstack_db_flavor}"
        
        # OpenStack config
        username = "${var.openstack_username}"
        tenant_name = "${var.openstack_tenant_name}"
        password = "${var.openstack_password}"
        region = "${var.openstack_region}"
        auth_url = "${var.openstack_auth_url}"
        pub_net_id = "${var.openstack_pub_net_id}"
    }

    module "centos_db_provisioner" {
        source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/db-server"
        
        # Server Info
        servers = "${var.openstack_db_servers}"
        server_ips = ["${module.openstack_db.nodes_floating_ips}"]

        # Login Information
        user_login = "${var.openstack_db_user_login}"
        public_key = "${file("${var.public_key_file}")}"
        key_file_path = "${var.private_key_file}"
    }

    output "openstack_db_ips" {
        value = ["${module.openstack_db.nodes_floating_ips}"]
    }

### [OpenStack Variables](./examples/openstack/multiple-servers/openstack.sample.tfvars)

    # Global Variables 
    public_key_file = "/path/to/public-key"
    private_key_file = "/path/to/private-key"

    # OpenStack Instance Variables
    openstack_app_servers = 2
    openstack_app_user_login = "root"
    openstack_app_image = "YOUR_OPENSTACK_PROVIDER_IMAGE"
    openstack_app_flavor = "YOUR_OPENSTACK_PROVIDER_FLAVOR"

    openstack_db_servers = 1
    openstack_db_user_login = "root"
    openstack_db_image = "YOUR_OPENSTACK_PROVIDER_IMAGE"
    openstack_db_flavor = "YOUR_OPENSTACK_PROVIDER_FLAVOR"

    # OpenStack Provider Variables
    openstack_username = "YOUR_OPENSTACK_USERNAME"
    openstack_tenant_name = "YOUR_OPENSTACK_TENANT_NAME"
    openstack_password = "YOUR_OPENSTACK_PASSWORD"
    openstack_region = "YOUR_OPENSTACK_REGION"
    openstack_auth_url = "YOUR_OPENSTACK_PROVIDER_IDENTITY_ENDPOINT"
    openstack_pub_net_id = "public"


## Microsoft Azure

### Inputs

  * prefix - The prefix you want to label all your server nodes and other resources as, defaults to `apache`
  * subscription_id - Your Azure Subscription Id
  * client_id - Your Azure Active Directory App Id
  * client_secret - Your Azure Active Directory Password / Secret
  * tenant_id - Your Account or Tenant Id
  * public_key - The contents of your public key you want to use for your key-pair
  * key_file_path - The path to your private key of the above public key which will be used to login to the servers
  * servers - The number of servers you want to spin up
  
Microsoft Azure Defaults

  * location - The region you want to use for these resources
  * vm_size - The type/size of VM you want to launch
  * user_login - The default user that is used on the your Azure image
  * image_publisher - The publisher of the image you want to use
  * image_offer - The name of the image you want to use 
  * image_sku - The release or ID of the image you want to use
  * image_version - The version of the image you want to use

### Outputs

  * vm_pips - a list of the public ips of your server nodes
  * vm_ids - a list of the Virtal Machine ids of your server nodes

### [Azure Example](./examples/azure/single-server/azure_example.tf)

    module "azure_app" {
        source = "github.com/kzap/terraform-modules//providers/azure/app-server"

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
        source = "github.com/kzap/terraform-modules//provisioners/bash/centos-7/app-db-server"
        
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

### [Azure Variables](./examples/azure/single-server/azure.sample.tfvars)

    # Global Variables 
    public_key_file = "/path/to/public-key"
    private_key_file = "/path/to/private-key"

    # Azure Provider Variables
    azure_subscription_id = "YOUR_AZURE_SUBSCRIPTION_ID"
    azure_client_id = "YOUR_AZURE_CLIENT_ID"
    azure_client_secret = "YOUR_AZURE_CLIENT_SECRET"
    azure_tenant_id = "YOUR_AZURE_TENANT_ID"
    azure_location = "YOUR_AZURE_LOCATION"

    # AWS Instance Variables
    azure_servers = 1


## Multiple Providers

This example uses the three previous examples as modules and sets them all up using a single configuration file.

### [Multiple Providers Example](./examples/multiple-providers/multi_example.tf)

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

### [Multiple Providers Variables](./examples/multiple-providers/multi.sample.tfvars)

    # Global Variables 
    public_key_file = "/path/to/public-key"
    private_key_file = "/path/to/private-key"

    # AWS Provider Variables
    aws_region = "YOUR_AWS_REGION"
    aws_access_key = "YOUR_AWS_ACCESS_KEY"
    aws_secret_key = "YOUR_AWS_SECRET_KEY"
    aws_key_name = "YOUR_AWS_KEYPAIR_NAME"

    # AWS Instance Variables
    aws_app_servers = 2
    aws_app_azs = ["LIST", "OF", "AZS"]
    aws_app_ami_id = "YOUR_AWS_AMI"
    aws_app_instance_type = "t2.micro"

    aws_db_servers = 1
    aws_db_azs = ["LIST", "OF", "AZS"]
    aws_db_ami_id = "YOUR_AWS_AMI"
    aws_db_instance_type = "t2.micro"


    # OpenStack Provider Variables
    openstack_username = "YOUR_OPENSTACK_USERNAME"
    openstack_tenant_name = "YOUR_OPENSTACK_TENANT_NAME"
    openstack_password = "YOUR_OPENSTACK_PASSWORD"
    openstack_region = "YOUR_OPENSTACK_REGION"
    openstack_auth_url = "YOUR_OPENSTACK_PROVIDER_IDENTITY_ENDPOINT"
    openstack_pub_net_id = "public"

    # OpenStack Instance Variables
    openstack_app_servers = 2
    openstack_app_user_login = "root"
    openstack_app_image = "YOUR_OPENSTACK_PROVIDER_IMAGE"
    openstack_app_flavor = "YOUR_OPENSTACK_PROVIDER_FLAVOR"

    openstack_db_servers = 1
    openstack_db_user_login = "root"
    openstack_db_image = "YOUR_OPENSTACK_PROVIDER_IMAGE"
    openstack_db_flavor = "YOUR_OPENSTACK_PROVIDER_FLAVOR"


    # Azure Provider Variables
    azure_subscription_id = "YOUR_AZURE_SUBSCRIPTION_ID"
    azure_client_id = "YOUR_AZURE_CLIENT_ID"
    azure_client_secret = "YOUR_AZURE_CLIENT_SECRET"
    azure_tenant_id = "YOUR_AZURE_TENANT_ID"
    azure_location = "YOUR_AZURE_LOCATION"

    # Azure Instance Variables
    azure_app_servers = 2

    azure_db_servers = 1


# LICENSE

Apache2 - See the included LICENSE file for more information.
