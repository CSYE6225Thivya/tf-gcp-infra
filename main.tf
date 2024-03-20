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


# Resource to create CloudSQL instance
resource "google_sql_database_instance" "cloudsql_instance" {
  name             = var.cloudsql_instance_name
  database_version = var.mysql_db_version
  region           = var.region
  deletion_protection = var.deletion_protection
 
  settings {
    tier              = var.sql_tier
    disk_type         = var.disk_type
    disk_size         = var.disk_size
    availability_type  = var.availability_type
  backup_configuration {
      enabled            = var.backup_configuration_enabled
      binary_log_enabled = var.binary_log_enabled 
    }
   ip_configuration {
      psc_config {
        psc_enabled               = var.psc_enabled 
        allowed_consumer_projects = [var.project_id]
      }
      ipv4_enabled = var.ipv4_enabled_cloudsql_instance
    }
  }
}

resource "google_compute_global_address" "peer_address" {
  name          = var.peer_address_name 
  address_type  = var.address_type 
  prefix_length = var.prefix_length 
  purpose       = var.purpose 
  network       = google_compute_network.my_vpc.self_link
}
 
resource "google_service_networking_connection" "private_connection" {
  network                 = google_compute_network.my_vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peer_address.name]
}
 
resource "google_compute_address" "endpointip" {
  name         = "psc-compute-address-${google_sql_database_instance.cloudsql_instance.name}"
  region       = var.region
  address_type = var.address_type_endpointip 
  subnetwork   = google_compute_subnetwork.db_subnet.id
  address      = var.endpointip 
}
 
resource "google_compute_forwarding_rule" "default" {
  name                  = "psc-forwarding-rule-${google_sql_database_instance.cloudsql_instance.name}"
  region                = var.region
  subnetwork            = google_compute_subnetwork.db_subnet.id
  ip_address            = google_compute_address.endpointip.id
  load_balancing_scheme = ""
  target                = google_sql_database_instance.cloudsql_instance.psc_service_attachment_link
}


# Resource to create sql database
resource "google_sql_database" "webapp_db" {
  name     = var.sqldb_name 
  instance = google_sql_database_instance.cloudsql_instance.name
}

# Resource to create random password
resource "random_password" "sql_user_password" {
  length  = var.random_password_length 
  special = var.random_password_special 
}

# Resource to create CloudSQL user
resource "google_sql_user" "sql_user" {
  name     = var.sqluser_name 
  instance = google_sql_database_instance.cloudsql_instance.name
  password = random_password.sql_user_password.result
}


# Resource to manage A record in Cloud DNS zone
resource "google_dns_record_set" "A_record" {
  name    =  var.dns_record_name
  type    =  var.dns_record_type
  ttl     = var.ttl_limit
  managed_zone = var.managed_zone_name

  rrdatas = [google_compute_instance.vpc_instance.network_interface.0.access_config.0.nat_ip]
}

# Resource to create service account
resource "google_service_account" "vm_service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}


# Bind Logging Admin role to the service account
resource "google_project_iam_binding" "logging_admin_binding" {
  project = var.project_id
  role    = var.logging_admin_binding

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}

# Bind Monitoring Metric Writer role to the service account
resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  project = var.project_id
  role    = var.monitoring_metric_writer_binding

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}


# Resource to create instance
resource "google_compute_instance" "vpc_instance" {
  name         = var.custom_image_instance_name
  machine_type = var.custom_image_instance_machine_type
  zone         = var.custom_image_instance_zone
  allow_stopping_for_update = true
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

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }


  depends_on = [
    google_sql_database_instance.cloudsql_instance,
    google_sql_user.sql_user,
    google_compute_address.endpointip,
    google_service_account.vm_service_account,
    google_project_iam_binding.logging_admin_binding,
    google_project_iam_binding.monitoring_metric_writer_binding
  ]
metadata_startup_script = <<-EOF
  #!/bin/bash
  ENV_FILE="/opt/webapp/.env"
  if [ ! -f "$ENV_FILE" ]; then
    echo "HOST=${google_compute_address.endpointip.address}" > /opt/webapp/.env
    echo "DB_PASSWORD=${google_sql_user.sql_user.password}" >> /opt/webapp/.env
    echo "DB_USER=${google_sql_user.sql_user.name}" >> /opt/webapp/.env
    echo "DB=${google_sql_database.webapp_db.name}" >> /opt/webapp/.env
    echo "DIALECT=mysql" >> /opt/webapp/.env
    echo "LOGPATH=/var/log/webapp/app.log" >> /opt/webapp/.env
  else
      echo "The file $ENV_FILE already exists."
  fi
  sudo ./opt/webapp/packer-config/configure_systemd.sh
  EOF
}




