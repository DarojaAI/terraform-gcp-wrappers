variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "postgres_db_password" {
  type        = string
  description = "Password for the PostgreSQL application user"
  sensitive   = true
}

variable "instance_name" {
  type        = string
  description = "Name of the Compute Engine instance hosting PostgreSQL"
}

variable "repo_prefix" {
  type        = string
  description = "Short prefix used for resource naming (e.g., repo nickname)"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., prod, staging, dev)"
}

variable "vpc_name" {
  type        = string
  description = "VPC network name (managed externally)"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name (managed externally)"
}

variable "network_id" {
  type        = string
  description = "VPC network self_link or id"
}

variable "subnet_id" {
  type        = string
  description = "Subnet self_link or id"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR range of the subnet"
}

variable "postgres_version" {
  type        = string
  default     = "15"
  description = "PostgreSQL major version"
}

variable "postgres_db_name" {
  type        = string
  default     = "app_database"
  description = "Name of the application database"
}

variable "postgres_db_user" {
  type        = string
  default     = "app_user"
  description = "Name of the application database user"
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
  description = "Compute Engine machine type for the PostgreSQL VM"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region for resources"
}

variable "allowed_source_cidrs" {
  type        = list(string)
  default     = []
  description = "CIDRs allowed to reach PostgreSQL (e.g. [module.vpc.subnet_cidr])"
}

variable "vpc_connector_cidr" {
  type        = string
  default     = ""
  description = "/28 CIDR for VPC connector. Leave empty if using direct VPC egress."
}
