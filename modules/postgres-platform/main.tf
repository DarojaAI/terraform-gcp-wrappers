# =============================================================================
# PostgreSQL Platform Module
# =============================================================================
# Organizational wrapper around gcp-postgres-terraform with VPC-only defaults.
# Exposes all underlying variables including init_sql and assign_external_ip.
#
# Migration from postgres-stack:
#   - Inner module name stays "postgres" → state addresses unchanged
#   - assign_external_ip defaults to false (was hardcoded true in postgres-stack)
#   - init_sql is now passed through (was omitted in postgres-stack)
# =============================================================================

module "postgres" {
  source  = "git::https://github.com/DarojaAI/gcp-postgres-terraform.git//terraform?ref=v4.2.1"

  # ---------------------------------------------------------------------------
  # Required inputs (passed through from caller)
  # ---------------------------------------------------------------------------
  project_id           = var.project_id
  postgres_db_password = var.postgres_db_password
  instance_name        = var.instance_name
  repo_prefix          = var.repo_prefix
  environment          = var.environment

  # ---------------------------------------------------------------------------
  # VPC linkage (received from caller — does NOT create VPC)
  # ---------------------------------------------------------------------------
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  network_id  = var.network_id
  subnet_id   = var.subnet_id
  subnet_cidr = var.subnet_cidr

  # ---------------------------------------------------------------------------
  # PostgreSQL config (passed through)
  # ---------------------------------------------------------------------------
  postgres_version = var.postgres_version
  postgres_db_name = var.postgres_db_name
  postgres_db_user = var.postgres_db_user
  machine_type     = var.machine_type
  region           = var.region
  zone             = var.zone

  # ---------------------------------------------------------------------------
  # Disk and machine (passed through)
  # ---------------------------------------------------------------------------
  disk_size_gb                = var.disk_size_gb
  disk_type                   = var.disk_type
  backup_bucket_force_destroy = var.backup_bucket_force_destroy
  log_all_statements          = var.log_all_statements

  # ---------------------------------------------------------------------------
  # Networking (passed through with VPC-only defaults)
  # ---------------------------------------------------------------------------
  assign_external_ip    = var.assign_external_ip    # default: false (VPC-only)
  allow_ssh_from_cidrs  = var.allow_ssh_from_cidrs  # default: []
  allow_postgres_from_cidrs = var.allowed_source_cidrs
  vpc_connector_cidr    = var.vpc_connector_cidr
  vpc_connector_min_instances = var.vpc_connector_min_instances
  vpc_connector_max_instances = var.vpc_connector_max_instances

  # ---------------------------------------------------------------------------
  # Backup configuration (passed through with organizational defaults)
  # ---------------------------------------------------------------------------
  enable_backups          = var.enable_backups          # default: true
  backup_bucket_name      = var.backup_bucket_name
  backup_retention_days   = var.backup_retention_days   # default: 30
  backup_schedule         = var.backup_schedule
  snapshot_retention_days = var.snapshot_retention_days

  # ---------------------------------------------------------------------------
  # Monitoring (passed through with organizational defaults)
  # ---------------------------------------------------------------------------
  enable_monitoring           = var.enable_monitoring           # default: true
  disk_usage_alert_threshold  = var.disk_usage_alert_threshold
  alert_notification_channels = var.alert_notification_channels

  # ---------------------------------------------------------------------------
  # PostgreSQL runtime tuning (passed through)
  # ---------------------------------------------------------------------------
  max_connections       = var.max_connections
  shared_buffers        = var.shared_buffers
  work_mem              = var.work_mem
  maintenance_work_mem  = var.maintenance_work_mem

  # ---------------------------------------------------------------------------
  # Schema injection (THE FIX — was omitted in postgres-stack)
  # ---------------------------------------------------------------------------
  init_sql        = var.init_sql        # default: ""
  pgvector_enabled = var.pgvector_enabled # default: true

  # ---------------------------------------------------------------------------
  # Cloud NAT (passed through with VPC-only default)
  # ---------------------------------------------------------------------------
  enable_cloud_nat = var.enable_cloud_nat  # default: true (required for no-external-IP)

  # ---------------------------------------------------------------------------
  # Advanced (passed through)
  # ---------------------------------------------------------------------------
  preemptible                     = var.preemptible
  github_actions_backup_reader_sa = var.github_actions_backup_reader_sa
  nat_project_id                  = var.nat_project_id
  allow_github_actions_ingress    = var.allow_github_actions_ingress
  enable_oslogin                  = var.enable_oslogin

  # ---------------------------------------------------------------------------
  # Labels (passed through)
  # ---------------------------------------------------------------------------
  labels = var.labels
}
