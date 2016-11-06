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