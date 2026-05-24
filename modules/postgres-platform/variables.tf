# =============================================================================
# PostgreSQL Platform Module — Variables
# =============================================================================
# All variables from gcp-postgres-terraform are exposed with VPC-only defaults.
#
# Key differences from postgres-stack:
#   - assign_external_ip: default false (was hardcoded true)
#   - init_sql: exposed (was omitted)
#   - enable_cloud_nat: default true (was hardcoded false)
#   - enable_monitoring: default true (was hardcoded false)
# =============================================================================

# ---------------------------------------------------------------------------
# Required Variables
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# VPC Linkage
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# PostgreSQL Configuration
# ---------------------------------------------------------------------------

variable "postgres_version" {
  type        = string
  default     = "15"
  description = "PostgreSQL major version (14, 15, or 16)"
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

variable "postgres_port" {
  type        = number
  default     = 5432
  description = "PostgreSQL port"
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

variable "zone" {
  type        = string
  default     = "us-central1-b"
  description = "GCP zone (must be within region)"
}

# ---------------------------------------------------------------------------
# Disk Configuration
# ---------------------------------------------------------------------------

variable "disk_size_gb" {
  type        = number
  default     = 30
  description = "Persistent disk size for PostgreSQL data in GB"
}

variable "disk_type" {
  type        = string
  default     = "pd-balanced"
  description = "Type of persistent disk (pd-standard, pd-ssd, pd-balanced)"
}

variable "backup_bucket_force_destroy" {
  type        = bool
  default     = true
  description = "Force destroy the backup bucket when running terraform destroy"
}

variable "log_all_statements" {
  type        = bool
  default     = false
  description = "Log all SQL statements (Warning: may contain sensitive data)"
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------

variable "assign_external_ip" {
  type        = bool
  default     = false
  description = "Assign an external (public) IP to the PostgreSQL VM. Default false for VPC-only."
}

variable "allow_ssh_from_cidrs" {
  type        = list(string)
  default     = []
  description = "CIDR ranges allowed to SSH to PostgreSQL VM (empty = disabled)"
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

variable "vpc_connector_min_instances" {
  type        = number
  default     = 2
  description = "Minimum instances for VPC connector"
}

variable "vpc_connector_max_instances" {
  type        = number
  default     = 10
  description = "Maximum instances for VPC connector"
}

# ---------------------------------------------------------------------------
# Backup Configuration
# ---------------------------------------------------------------------------

variable "enable_backups" {
  type        = bool
  default     = true
  description = "Enable daily automatic PostgreSQL backups to GCS"
}

variable "backup_bucket_name" {
  type        = string
  default     = ""
  description = "Name of GCS bucket for backups (auto-generated if empty)"
}

variable "backup_retention_days" {
  type        = number
  default     = 30
  description = "Number of days to retain backups"
}

variable "backup_schedule" {
  type        = string
  default     = "0 2 * * *"
  description = "Cron schedule for automated backups (default: 2am UTC daily)"
}

variable "snapshot_retention_days" {
  type        = number
  default     = 30
  description = "Number of days to retain disk snapshots"
}

# ---------------------------------------------------------------------------
# Monitoring
# ---------------------------------------------------------------------------

variable "enable_monitoring" {
  type        = bool
  default     = true
  description = "Enable Cloud Monitoring dashboards and alerts for PostgreSQL"
}

variable "disk_usage_alert_threshold" {
  type        = number
  default     = 80
  description = "Disk usage percentage threshold for alerts"
}

variable "alert_notification_channels" {
  type        = list(string)
  default     = []
  description = "List of notification channel IDs for alerts"
}

# ---------------------------------------------------------------------------
# PostgreSQL Runtime Tuning
# ---------------------------------------------------------------------------

variable "max_connections" {
  type        = number
  default     = 100
  description = "Maximum number of concurrent PostgreSQL connections"
}

variable "shared_buffers" {
  type        = string
  default     = "256MB"
  description = "PostgreSQL shared_buffers setting"
}

variable "work_mem" {
  type        = string
  default     = "4MB"
  description = "PostgreSQL work_mem setting"
}

variable "maintenance_work_mem" {
  type        = string
  default     = "64MB"
  description = "PostgreSQL maintenance_work_mem setting"
}

# ---------------------------------------------------------------------------
# Schema Injection (THE FIX)
# ---------------------------------------------------------------------------

variable "init_sql" {
  type        = string
  default     = ""
  description = "SQL to run after PostgreSQL and pgvector are installed (schema creation, extensions, grants). Can be multi-statement."
}

variable "pgvector_enabled" {
  type        = bool
  default     = true
  description = "Enable pgvector extension for vector similarity search"
}

# ---------------------------------------------------------------------------
# Cloud NAT
# ---------------------------------------------------------------------------

variable "enable_cloud_nat" {
  type        = bool
  default     = true
  description = "Enable Cloud NAT for outbound internet access (required if VM has no public IP)"
}

# ---------------------------------------------------------------------------
# Advanced
# ---------------------------------------------------------------------------

variable "preemptible" {
  type        = bool
  default     = false
  description = "Use preemptible VM (lower cost but may be terminated by GCP)"
}

variable "github_actions_backup_reader_sa" {
  type        = string
  default     = ""
  description = "GitHub Actions deploy SA email that needs read access to the backup bucket"
}

variable "nat_project_id" {
  type        = string
  default     = ""
  description = "Project containing the Cloud NAT router (defaults to project_id)"
}

variable "allow_github_actions_ingress" {
  type        = bool
  default     = false
  description = "Allow GitHub Actions runners to connect to PostgreSQL"
}

variable "enable_oslogin" {
  type        = bool
  default     = true
  description = "Enable OS Login for SSH access"
}

# ---------------------------------------------------------------------------
# Labels
# ---------------------------------------------------------------------------

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to all resources"
}
