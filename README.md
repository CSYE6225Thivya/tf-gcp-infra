# tf-gcp-infra

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



