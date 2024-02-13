# This Terraform configuration sets up networking resources on GCP.
# It creates VPC with two subnets: webapp and db, and adds a route to the webapp subnet.


# Provider configuration for GCP
provider "google" {
  project = var.project_id
  region  = var.region
}

# Resource to create VPC
resource "google_compute_network" "my_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes_on_create
}

#Resource to create subnet named webapp
resource "google_compute_subnetwork" "webapp_subnet" {
  name          = var.webapp_subnet_name
  region        = var.region
  network       = google_compute_network.my_vpc.self_link
  ip_cidr_range = var.webapp_subnet_cidr
}

#Resource to create subnet named db
resource "google_compute_subnetwork" "db_subnet" {
  name          = var.db_subnet_name
  region        = var.region
  network       = google_compute_network.my_vpc.self_link
  ip_cidr_range = var.db_subnet_cidr
}

# Resource to create route for webapp subnet
resource "google_compute_route" "webapp_route" {
  name                  = var.webapp_route_name 
  network               = google_compute_network.my_vpc.self_link
  dest_range            = var.route_range
  next_hop_gateway      = var.next_hop_gateway 
}
