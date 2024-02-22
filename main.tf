# This Terraform configuration sets up networking resources on GCP.
# It creates VPC with two subnets: webapp and db, and adds a route to vpc.


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
resource "google_compute_route" "vpc_route" {
  name                  = var.vpc_route_name 
  network               = google_compute_network.my_vpc.self_link
  dest_range            = var.route_range
  next_hop_gateway      = var.next_hop_gateway 
}

# Resource to create firewall
resource "google_compute_firewall" "vpc_firewall" {
  name    = var.firewall_http
  network = google_compute_network.my_vpc.self_link
  priority    = var.priority_allow

  allow {
    protocol = var.protocol_http
    ports    = var.ports_http 
  }

  source_ranges = var.source_ranges_http
  target_tags   = var.target_tags_http
}

# Resource to deny firewall
resource "google_compute_firewall" "deny-ssh" {
  name    = var.firewall_ssh
  network = google_compute_network.my_vpc.self_link
  priority    = var.priority_deny
 
  deny {
    protocol = var.protocol_ssh
  }
 
  source_ranges = var.source_ranges_ssh
  target_tags   = var.target_tags_ssh 
}

# Resource to create instance
resource "google_compute_instance" "vpc_instance" {
  name         = var.custom_image_instance_name
  machine_type = var.custom_image_instance_machine_type
  zone         = var.custom_image_instance_zone
boot_disk {
    initialize_params {
      image = var.instance_name
      size  = var.custom_image_instance_bootdisk_size
      type  = var.custom_image_instance_bootdisk_type
    }
  }
network_interface {
    network = google_compute_network.my_vpc.self_link
    subnetwork = google_compute_subnetwork.webapp_subnet.self_link  
    access_config {   
    }
  }
  tags = var.network_tag 
}






