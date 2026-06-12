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
  source = "git::https://github.com/DarojaAI/gcp-postgres-terraform.git//terraform?ref=v4.3.0"

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
  postgres_port    = var.postgres_port

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
  assign_external_ip          = var.assign_external_ip   # default: false (VPC-only)
  allow_ssh_from_cidrs        = var.allow_ssh_from_cidrs # default: []
  allow_postgres_from_cidrs   = var.allowed_source_cidrs
  vpc_connector_cidr          = var.vpc_connector_cidr
  vpc_connector_min_instances = var.vpc_connector_min_instances
  vpc_connector_max_instances = var.vpc_connector_max_instances

  # ---------------------------------------------------------------------------
  # Backup configuration (passed through with organizational defaults)
  # ---------------------------------------------------------------------------
  enable_backups          = var.enable_backups # default: true
  backup_bucket_name      = var.backup_bucket_name
  backup_retention_days   = var.backup_retention_days # default: 30
  backup_schedule         = var.backup_schedule
  snapshot_retention_days = var.snapshot_retention_days

  # ---------------------------------------------------------------------------
  # Monitoring (passed through with organizational defaults)
  # ---------------------------------------------------------------------------
  enable_monitoring           = var.enable_monitoring # default: true
  disk_usage_alert_threshold  = var.disk_usage_alert_threshold
  alert_notification_channels = var.alert_notification_channels

  # ---------------------------------------------------------------------------
  # PostgreSQL runtime tuning (passed through)
  # ---------------------------------------------------------------------------
  max_connections      = var.max_connections
  shared_buffers       = var.shared_buffers
  work_mem             = var.work_mem
  maintenance_work_mem = var.maintenance_work_mem

  # ---------------------------------------------------------------------------
  # Schema injection (THE FIX — was omitted in postgres-stack)
  # ---------------------------------------------------------------------------
  init_sql         = var.init_sql         # default: ""
  pgvector_enabled = var.pgvector_enabled # default: true

  # ---------------------------------------------------------------------------
  # Cloud NAT (passed through with VPC-only default)
  # ---------------------------------------------------------------------------
  enable_cloud_nat = var.enable_cloud_nat # default: true (required for no-external-IP)

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

# ----------------------------------------------------------------------------
# vm_changed signal — for CI post-apply wait gating
# ----------------------------------------------------------------------------
# Reads the postgres VM's current state from GCP. If the instance exists,
# it was created in a previous apply and doesn't need a fresh boot wait.
# If the instance is being created or replaced in this apply, the data
# source will fail to find it (or find the new one mid-replace), and
# `vm_changed` returns `true` — meaning the caller should wait for boot.
#
# Why a data source (not lifecycle_operation):
#   - `lifecycle_operation` is a resource-level attribute, not exposed
#     through the inner `gcp-postgres-terraform` module's outputs. To
#     read it from this wrapper, we'd have to fork the inner module.
#   - A data source lookup at plan time gives the same signal ("is this
#     instance brand new?") without touching the inner module. The data
#     source is evaluated at plan time, so the signal is available to
#     the caller's plan-phase gating logic.
#   - This matches the Python fallback in dev-nexus
#     (`scripts/ci/detect_pg_vm_changed.py`) — both read plan-time
#     state to decide whether the VM will (re)boot.
#
# Use case: gate the post-apply `gcloud compute instances
# get-serial-port-output` poll in CI workflows. Saves up to 15 min of
# CI time on no-op applies (the common case for most PRs).
# ----------------------------------------------------------------------------
data "google_compute_instance" "postgres" {
  project = var.project_id
  name    = module.postgres.instance_name
  zone    = module.postgres.zone
}
