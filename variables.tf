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

variable "webapp_route_name" {
  description = "Name of the webapp subnet route"
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

