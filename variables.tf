variable "project_id" {
  description = "The ID of the GCP project"
}

variable "region" {
  description = "The region for the resources"
}

variable "vpc_name" {
  description = "Name of the VPC"
}

variable "auto_create_subnetworks" {
   description = "Boolean value to not create subnetworks"
}

variable "delete_default_routes_on_create" {
   description = "Boolean value to delete default routes on create"
}

variable "webapp_subnet_name" {
  description = "Name of the webapp subnet"
}

variable "db_subnet_name" {
  description = "Name of the db subnet"
}

variable "webapp_subnet_cidr" {
  description = "CIDR range for the webapp subnet"
}

variable "db_subnet_cidr" {
  description = "CIDR range for the db subnet"
}

variable "vpc_route_name" {
  description = "Name of the vpc route"
}

variable "routing_mode" {
  description = "Name of the routing mode"
}

variable "route_range" {
  description = "Range for the webapp subnet route"
}

variable next_hop_gateway {
  description = "value for next_hop_gateway"
}

variable firewall_http {
  description = "Name of the firewall"
}

variable "protocol_http" {
  description = "Protocol for the firewall rule"
}

variable "ports_http" {
  description = "List of ports to allow traffic"
}

variable "source_ranges_http" {
  description = "List of source IP ranges to allow traffic from"
}

variable "target_tags_http" {
  description = "List of target tags to apply the firewall rule to"
}

variable "source_ranges_ssh" {
  description = "List of source IP ranges to deny traffic from"
}

variable "target_tags_ssh" {
  description = "List of target tags to deny the firewall rule to"
}

variable "protocol_ssh" {
  description = "Protocol for the firewall rule"
}

variable "custom_image_instance_name" {
  description = "Name of the custom image instance name"
}

variable "custom_image_instance_machine_type" {
  description = "Name of the custom image instance machine type"
}

variable "custom_image_instance_zone" {
  description = "Name of the custom image instance zone"
}

variable "custom_image_instance_bootdisk_size" {
  description = "Size of the custom image instance bootdisk"
}

variable "custom_image_instance_bootdisk_type" {
  description = "Type of the custom image instance bootdisk"
}

variable firewall_ssh {
  description = "Name of the deny ssh firewall"
}

variable network_tag {
  description = "Name of the network tag"
}

variable instance_name {
  description = "Name of the instance"
}


variable priority_allow {
  description = "Priority allow"
}
variable priority_deny {
  description = "Priority deny"
}

variable "cloudsql_instance_name" {
  description = "Name of mysql instance"
}


variable "mysql_db_version" {
  description = "mysql db version"
}

variable "deletion_protection" {
  description = "Controls whether deletion protection is enabled for the SQL instance. When deletion protection is enabled, it prevents the instance from being deleted accidentally"
}

variable "availability_type" {
  description = "Specifies the availability type for SQL instance"
}

variable "sql_tier" {
  description = "Represents the tier SQL instance"
}

variable "disk_type" {
  description = "Defines the type of disk"
}

variable "disk_size" {
  description = "Specifies the size of the disk"
}

variable "ipv4_enabled" {
  description = "Controls whether IPv4 is enabled for SQL instance"
}

variable "sqldb_name" {
  description = "Name of the DB"
}

variable "sqluser_name" {
  description = "Name of the sql user"
}

variable "backup_configuration_enabled" {
  description = "Backup configuration status"
}

variable "binary_log_enabled" {
  description = "Binary log status"
}

variable "psc_enabled" {
  description = "psc enabled status"
}
variable "ipv4_enabled_cloudsql_instance" {
  description = "ipv4 enabled status"
}

variable "peer_address_name" {
  description = "Name of the global address"
}
variable "address_type" {
  description = "Name of the global address type"
}

variable "prefix_length" {
  description = "Prefix length of the global address"
}
variable "purpose" {
  description = "Purpose of the global address"
}
variable "endpointip" {
  description = "IP address of the endpoint"
}
variable "address_type_endpointip" {
  description = "Address type of the endpoint"
}

variable "random_password_special" {
  description = "random_password attribute"
}

variable "random_password_length" {
  description = "random_password length"
}

variable "dns_record_name" {
  description = "The name of the dns record set"
}

variable "dns_record_type" {
  description = "DNS record type"
}

variable "ttl_limit" {
  description = "TTL limit"
}

variable "managed_zone_name" {
  description = "Name of the managed zone"
}

variable "service_account_id" {
  description = "Name of the service account id"
}

variable "service_account_display_name" {
  description = "Name of the service account display name"
}

variable "logging_admin_binding" {
  description = "IAM binding for roles/logging.admin"
}

variable "monitoring_metric_writer_binding" {
  description = "IAM binding for roles/monitoring.metricWriter"
}

variable "my_topic_name" {
  description = "Name of the pub/sub topic"
}

variable "message_retention_duration" {
  description = "message retention duration for topic"
}

variable "google_project_iam_binding_function_iam_binding_role" {
  description = "Role binding for function"
}

variable "google_pubsub_topic_iam_binding_topic_iam_binding_role" {
  description = "Role binding for topic"
}

variable "google_project_iam_binding_service_account_token_creator_binding_role" {
  description = "Role binding for service account token creator"
}

variable "google_project_iam_member_cloudsql_client_role_binding_role" {
  description = "Role binding for cloudsql client"
}

variable "google_cloudfunctions_function_name" {
  description = "Name of the cloud function"
}

variable "google_cloudfunctions_function_runtime" {
  description = "Runtime of the cloud function"
}

variable "source_archive_bucket" {
  description = "Name of the source bucket"
}

variable "source_archive_object" {
  description = "Name of the source object"
}

variable "entry_point" {
  description = "Entry point of cloud function"
}

variable "google_vpc_access_connector_name" {
  description = "Name of the vpc access connector"
}

variable "google_vpc_access_connector_ipcidrrange" {
  description = "ip cidr range of vpc access connector"
}

variable "dialect" {
  description = "Dialect value"
}

variable "api_key_mailgun" {
  description = "API key of mailgun"
}

variable "my_domain_name" {
  description = "Domain name"
}

variable "sendermail_mailgun" {
  description = "Sender mail id from mailgun"
}

variable "base_url_link" {
  description = "Base url path"
}

variable "private_ip_google_access_webapp_subnet" {
  description = "Private google access"
}


variable "lb_global_address_name" {
  description = "Global address for load balancer"
}


variable "deny_ssh_port" {
  description = "Deny firewall ranges"
}



variable "vpc_firewall_source_ranges" {
  description = "Firewall source ranges"
}
variable "webapp_template_name" {
  description = "Webapp template name"
}
variable "webapp_template_description" {
  description = "Webapp template description"
}
variable "webapp_template_machine_type" {
  description = "Webapp template machine type"
}

variable "webapp_health_check_name" {
  description = "webapp health check name"
}

variable "webapp_health_check_check_interval_sec" {
  description = "webapp health check interval sec"
}

variable "webapp_health_check_timeout_sec" {
  description = "webapp health check timeout sec"
}
variable "webapp_health_check_healthy_threshold" {
  description = "webapp health check healthy threshold"
}
variable "webapp_health_check_unhealthy_threshold" {
  description = "webapp health check unhealthy threshold"
}

variable "webapp_health_check_port" {
  description = "webapp health check port"
}
variable "webapp_health_check_port_name" {
  description = "webapp health check port name"
}

variable "webapp_health_check_request_path" {
  description = "webapp health check request path"
}
variable "webapp_autoscaler_name" {
  description = "webapp autoscaler name"
}
variable "min_replicas" {
  description = "webapp autoscaler min replicas of instance"
}

variable "max_replicas" {
  description = "webapp autoscaler max replicas of instance"
}
variable "cooldown_period" {
  description = "webapp autoscaler cooldown period"
}
variable "cpu_utilization" {
  description = "webapp autoscaler cpu utilization"
}

variable "webapp_instance_group_manager_name" {
  description = "webapp instance group manager name"
}
variable "webapp_instance_group_manager_base_instance_name" {
  description = "webapp instance group manager base instance name"
}

variable "distribution_policy_zones" {
  description = "webapp instance group manager distribution policy zones"
}
variable "named_port_name" {
  description = "Name of the named port"
}

variable "named_port_port" {
  description = "Port of the named port"
}

variable "instance_lifecycle_policy" {
  description = "Define Instance lifecycle policy"
}

variable "auto_healing_policies_initial_delay_sec" {
  description = "auto healing policies initial delay sec"
}
variable "ssl_certificate_lb_name" {
  description = "ssl certificate name"
}
variable "ssl_certificate_lb_domain" {
  description = "ssl certificate managed domain name"
}
variable "backend_service_name" {
  description = "backend service name of load balancer"
}
variable "backend_service_protocol" {
  description = "backend service protocol of load balancer"
}
variable "backend_service_timeout_sec" {
  description = "backend service timeout sec of load balancer"
}
variable "backend_service_port_name" {
  description = "backend service port name  of load balancer"
}
variable "load_balancing_scheme" {
  description = "backend service load balancing scheme  of load balancer"
}
variable "backend_service_balancing_mode" {
  description = "backend service balancing mode of load balancer"
}

variable "capacity_scaler" {
  description = "backend service capacity scaler of load balancer"
}
variable "backend_service_enable_cdn" {
  description = "backend service enable cdn of load balancer"
}
variable "url_map_name" {
  description = "url map name"
}

variable "https_proxy_name" {
  description = "https proxy name"
}
variable "webapp_lb_forwarding_rule_https_name" {
  description = "webapp lb forwarding rule https name "
}

variable "webapp_lb_forwarding_rule_https_ip_protocol" {
  description = "webapp lb forwarding rule https ip protocol "
}

variable "webapp_lb_forwarding_rule_https_port_range" {
  description = "webapp lb forwarding rule https port range "
}
variable "webapp_lb_forwarding_rule_https_load_balancing_scheme" {
  description = "webapp lb forwarding rule https load balancing scheme "
}





















