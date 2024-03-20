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










