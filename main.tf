# This Terraform configuration sets up networking resources on GCP.
# It creates VPC with three subnets: webapp, db and backend, and adds a route to vpc.


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
  private_ip_google_access = var.private_ip_google_access_webapp_subnet
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


# Define the global address for the load balancer
resource "google_compute_global_address" "lb_global_address" {
  project = var.project_id
  name          =  var.lb_global_address_name
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

# Resource to create firewall rule for HTTP traffic

 resource "google_compute_firewall" "vpc_firewall" {
  name    = var.firewall_http
  network = google_compute_network.my_vpc.self_link
  

  allow {
    protocol = var.protocol_http
    ports    = var.ports_http 
  }

  source_ranges =  var.vpc_firewall_source_ranges
  target_tags   = var.target_tags_http
  
}

# Resource to deny firewall
resource "google_compute_firewall" "deny-ssh" {
  name    = var.firewall_ssh
  network = google_compute_network.my_vpc.self_link
 
 
  allow {
    protocol = var.protocol_ssh
    ports =  var.deny_ssh_port
  }
 
  source_ranges = var.source_ranges_ssh
  target_tags   = var.target_tags_http 
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

# Resource to create Pub/Sub topic
resource "google_pubsub_topic" "my_topic" {
  name                = var.my_topic_name
  message_retention_duration = var.message_retention_duration
}

# IAM binding for Cloud Functions
resource "google_project_iam_binding" "function_iam_binding" {
  project = var.project_id
  role    = var.google_project_iam_binding_function_iam_binding_role
  members = [
  "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}



# Resource to create VPC Connector
resource "google_vpc_access_connector" "my_vpc_connector" {
  name            = var.google_vpc_access_connector_name
  region          = var.region
  network         = google_compute_network.my_vpc.name
  ip_cidr_range   = var.google_vpc_access_connector_ipcidrrange
  min_throughput  = 200 
}

# Resource to create Cloud Function
resource "google_cloudfunctions_function" "my_function" {
  name        =  var.google_cloudfunctions_function_name
  runtime     =  var.google_cloudfunctions_function_runtime
  source_archive_bucket = var.source_archive_bucket
  source_archive_object = var.source_archive_object
  entry_point = var.entry_point

  available_memory_mb = 256
  timeout             = 60
  service_account_email = google_service_account.vm_service_account.email

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.my_topic.name
  }
   # Add VPC connector configuration
    vpc_connector = google_vpc_access_connector.my_vpc_connector.name

  environment_variables = {
    HOST        = google_compute_address.endpointip.address
    DB_PASSWORD = google_sql_user.sql_user.password
    DB_USER     = google_sql_user.sql_user.name
    DB          = google_sql_database.webapp_db.name
    DIALECT     = var.dialect
    API_KEY_MAILGUN     = var.api_key_mailgun
    DOMAIN_NAME_MAILGUN = var.my_domain_name
    SENDER_MAILGUN = var.sendermail_mailgun
    BASE_URL_LINK = var.base_url_link


   
  }
}

# IAM binding for Pub/Sub Topic
resource "google_pubsub_topic_iam_binding" "topic_iam_binding" {
  topic  = google_pubsub_topic.my_topic.name
  role   = var.google_pubsub_topic_iam_binding_topic_iam_binding_role
  members = [
     "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}

# IAM binding for serviceAccountTokenCreator
resource "google_project_iam_binding" "service_account_token_creator_binding" {
  project = var.project_id
  role    = var.google_project_iam_binding_service_account_token_creator_binding_role
  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}"
  ]
}

# Grant roles/cloudsql.client role to the Cloud Function's service account
resource "google_project_iam_member" "cloudsql_client_role_binding" {
  project = var.project_id
  role    = var.google_project_iam_member_cloudsql_client_role_binding_role
  member  = "serviceAccount:${google_service_account.vm_service_account.email}"
}



# Resource to create regional compute instance template
resource "google_compute_region_instance_template" "webapp_template" {
  name        =  var.webapp_template_name
  description = var.webapp_template_description
  machine_type = var.webapp_template_machine_type
  region = var.region
  disk {
    source_image = var.instance_name
    disk_size_gb = var.disk_size
    disk_type    = var.custom_image_instance_bootdisk_type
    auto_delete       = true
    boot              = true
  }
 
 network_interface {
    network    = google_compute_network.my_vpc.self_link
    subnetwork = google_compute_subnetwork.webapp_subnet.self_link
    access_config {   
     }
  }
  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    ENV_FILE="/opt/webapp/.env"
    if [ ! -f "$ENV_FILE" ]; then
      echo "HOST=10.0.2.3" > /opt/webapp/.env
      echo "DB_PASSWORD=${google_sql_user.sql_user.password}" >> /opt/webapp/.env
      echo "DB_USER=${google_sql_user.sql_user.name}" >> /opt/webapp/.env
      echo "DB=webapp" >> /opt/webapp/.env
      echo "DIALECT=mysql" >> /opt/webapp/.env
      echo "TOPIC_NAME=verify_email" >> /opt/webapp/.env
      echo "LOGPATH=/var/log/webapp/app.log" >> /opt/webapp/.env
    else
        echo "$ENV_FILE file already exists."
    fi
    sudo ./opt/webapp/packer-config/configure_systemd.sh
  EOF

  depends_on = [
    google_sql_database_instance.cloudsql_instance,
    google_sql_user.sql_user,
    google_compute_address.endpointip,
    google_service_account.vm_service_account,
    google_project_iam_binding.logging_admin_binding,
    google_project_iam_binding.monitoring_metric_writer_binding
  ]
  tags   = var.target_tags_http
}

# Resource to create health check
resource "google_compute_health_check" "webapp_health_check" {
  name               = var.webapp_health_check_name
  check_interval_sec =  var.webapp_health_check_check_interval_sec
  timeout_sec        =  var.webapp_health_check_timeout_sec
  healthy_threshold   = var.webapp_health_check_healthy_threshold
  unhealthy_threshold = var.webapp_health_check_unhealthy_threshold
  
  http_health_check {
    port =   var.webapp_health_check_port
    port_name = var.webapp_health_check_port_name
    request_path =  var.webapp_health_check_request_path
  }
  log_config {
    enable       = true
  }
}

# Resource to create autoscaler
resource "google_compute_region_autoscaler" "webapp_autoscaler" {
  name                  =  var.webapp_autoscaler_name
  region                = var.region
  target                = google_compute_region_instance_group_manager.webapp_instance_group_manager.self_link
  autoscaling_policy {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
    cooldown_period = var.cooldown_period
    cpu_utilization {
      target = var.cpu_utilization
    }
  }
    depends_on = [google_compute_region_instance_group_manager.webapp_instance_group_manager]

}

# Resource to create instance group manager
resource "google_compute_region_instance_group_manager" "webapp_instance_group_manager" {
  name = var.webapp_instance_group_manager_name
  base_instance_name = var.webapp_instance_group_manager_base_instance_name
  region = var.region
  distribution_policy_zones  = var.distribution_policy_zones 
 
  
  version {
    instance_template = google_compute_region_instance_template.webapp_template.self_link
  }

 named_port {
    name =  var.named_port_name
    port =  var.named_port_port
  }

  instance_lifecycle_policy {
    default_action_on_failure = var.instance_lifecycle_policy
  }
 auto_healing_policies {
    health_check = google_compute_health_check.webapp_health_check.self_link
    initial_delay_sec =  var.auto_healing_policies_initial_delay_sec
  }

  depends_on = [
    google_compute_region_instance_template.webapp_template,
    google_compute_health_check.webapp_health_check
  ]
}

# Resource to create ssl_certificate

resource "google_compute_managed_ssl_certificate" "ssl_certificate_lb" {
 
  name     = var.ssl_certificate_lb_name
  managed {
    domains =  var.ssl_certificate_lb_domain
  }

}

# Resource to create backend service for load balancer
resource "google_compute_backend_service" "backend_service" {
  name             = var.backend_service_name
  health_checks    = [google_compute_health_check.webapp_health_check.self_link]
  enable_cdn       =  var.backend_service_enable_cdn
  protocol         =  var.backend_service_protocol
  timeout_sec      = var.backend_service_timeout_sec
  port_name        = var.backend_service_port_name
  load_balancing_scheme   =  var.load_balancing_scheme
  backend {
    group           = google_compute_region_instance_group_manager.webapp_instance_group_manager.instance_group
    balancing_mode  = var.backend_service_balancing_mode
    capacity_scaler =  var.capacity_scaler
  }
  depends_on = [
    google_compute_health_check.webapp_health_check,
    google_compute_region_instance_group_manager.webapp_instance_group_manager
  ]
  
}

# Resource to create URL map for load balancer
resource "google_compute_url_map" "url_map" {
  name            =  var.url_map_name
  default_service = google_compute_backend_service.backend_service.self_link
}

# Resource to create target HTTPS proxy for load balancer
resource "google_compute_target_https_proxy" "https_proxy" {
  name               = var.https_proxy_name
  url_map            = google_compute_url_map.url_map.self_link
  ssl_certificates   = [google_compute_managed_ssl_certificate.ssl_certificate_lb.id]
}

# Resource to create global forwarding rule for load balancer
resource "google_compute_global_forwarding_rule" "webapp_lb_forwarding_rule_https" {
  name                  =  var.webapp_lb_forwarding_rule_https_name
  ip_address            = google_compute_global_address.lb_global_address.id
  ip_protocol           =  var.webapp_lb_forwarding_rule_https_ip_protocol
  port_range            =  var.webapp_lb_forwarding_rule_https_port_range
  load_balancing_scheme =  var.webapp_lb_forwarding_rule_https_load_balancing_scheme
  target                = google_compute_target_https_proxy.https_proxy.self_link
}

# Resource to manage A record in Cloud DNS zone 
resource "google_dns_record_set" "A_record" {
  name         = var.dns_record_name
  type         = var.dns_record_type
  ttl          = var.ttl_limit
  managed_zone = var.managed_zone_name
  rrdatas = [google_compute_global_address.lb_global_address.address]
}






