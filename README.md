# tf-gcp-infra
## Assignment - 3

# Infrastructure Setup with Terraform on GCP

This Terraform configuration sets up networking resources on GCP. It creates a Virtual Private Cloud (VPC) with two subnets: webapp and db, and adds a route to vpc.

GCP requires certain services to be enabled before you can use them. These services provide essential functionalities for deploying infrastructure using Terraform. 

Required service is
1. Compute Engine API: This API is necessary for creating networking resources such as VPC networks, subnets, and routes.
In Google Cloud Console—>APIs & Services > Dashboard—>Enable APIs and Services—>Search for "Compute Engine API”—>Click on Enable to enable the Compute Engine API for your project.

# Variables

- project_id: ID of the GCP project
- region: The region where resources will be deployed
- vpc_name: Name of the VPC created
- webapp_subnet_name: Name of the webapp subnet within the VPC
- db_subnet_name: Name of the db subnet within the VPC
- webapp_subnet_cidr: CIDR range for the webapp subnet
- db_subnet_cidr: CIDR range for the db subnet
- webapp_route_name: Name of the route added for the webapp subnet
- routing_mode: Routing mode for the VPC 
- route_range: Range for the webapp subnet route

# Terraform Resources

- google_compute_network.my_vpc: Creates VPC with the configuration provided
- google_compute_subnetwork.webapp_subnet: Creates webapp subnet within the VPC
- google_compute_subnetwork.db_subnet: Creates db subnet within the VPC
- google_compute_route.vpc_route: Adds route to vpc

# Implementation

1. 'terraform init' - to initialize Terraform configuration.
2. 'terraform plan' - to see the execution plan.
3. 'terraform apply' - to apply the configuration and create the networking resources on GCP.


## Assignment - 4
 
1. An instance created from the custom image is deployed on our web-app subnet.
2. Only 8080 port is allowed in our firewall and rest all ports denied using priority

## Assignment - 5
1. Private services access has been enabled in the VPC to enhance security("Service Networking API" enabled in GCP console).
2. Default configuration for CloudSQL instance including settings like deletion protection, availability type, disk type, size, and IPv4 settings is created.
3. Database named "webapp" has been created within the CloudSQL instance.
4. Created user named "webapp" with a randomly generated password for accessing the CloudSQL database.
5. Startup script was setup to create .env file to passes database configuration details to the web application

## Assignment - 6
Setting up Cloud DNS and Namecheap Integration
1. Acquiring a Domain Name from Namecheap:
- Go to Namecheap's website and log in to your specific account (or create one if you haven't already).
- Search for desired domain name using Namecheap's domain search tool.
Once you find an available domain name that you want to purchase, add it to your cart and complete the checkout process. (domain name is free using github student pack)

2. Registering the Domain in Google Cloud Platform:
- Log in to Google Cloud Platform (GCP) Console.
- Navigate to the Cloud DNS page by clicking on menu -- > Networking > Network Services > Cloud DNS.
- Click on the "Create zone" button.
- Enter the zone name (mycloudwebapp) and DNS name (mycloudwebapp.me)
- Click on the "Create" button to register the domain in Google Cloud Platform.

3. Obtain Custom Name Servers from Google Cloud DNS:
- After registering the domain in Google Cloud DNS, Google Cloud DNS will provide you with custom name servers.
- Note down these custom name servers as they will be used to update your domain's DNS settings in Namecheap.

4. Configuring Namecheap to Use Custom Name Servers:
- Log in to Namecheap account.
- Go to the "Domain List" section and find the domain you purchased.
- Click on the "Manage" button next to the domain.
- Navigate to the "Nameservers" section.
- Choose "Custom DNS" from the drop-down menu.
- Enter the custom name servers provided by Google Cloud DNS.
- Click on the checkmark icon to apply the changes.

Adding or Updating A Record:

1. Use "google_dns_record_set" resource in Terraform configuration to manage DNS record sets within Cloud DNS zone.
2. Set "name" to your desired domain name (ie, mycloudwebapp.me.).
3. Set "type" to "A" to indicate an A record.
4. Set "ttl" to the desired Time to Live value (e.g., "50" seconds).
5. Specify "managed_zone" with the name of your Cloud DNS zone. (ie, mycloudwebapp )
6. Set "rrdatas" with the IP address of your VM instance where the web application is hosted.

### Creating a Service Account:

1. Define a "google_service_account" resource in the Terraform configuration file to create the service account.
2. Specify the "account_id" and "display_name" for the service account.

Attaching the Service Account to the Virtual Machine:
1. Utilize the service_account block within the google_compute_instance resource to attach the service account to the virtual machine.
2. Set the email to the email address of the service account and define necessary scopes.

Binding IAM Roles to the Service Account:
1. Use google_project_iam_binding resources to bind the required IAM roles to the service account.
2. Define resource blocks for each IAM role specifying the project, role, and members(Roles are: Logging Admin &
Monitoring Metric Writer)

