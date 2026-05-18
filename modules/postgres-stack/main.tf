module "postgres" {
  source  = "git::https://github.com/DarojaAI/gcp-postgres-terraform.git//terraform?ref=v4.2.0"

  # Required inputs (passed through from caller)
  project_id           = var.project_id
  postgres_db_password = var.postgres_db_password
  instance_name        = var.instance_name
  repo_prefix          = var.repo_prefix
  environment          = var.environment

  # VPC linkage (received from caller — does NOT create VPC)
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  network_id  = var.network_id
  subnet_id   = var.subnet_id
  subnet_cidr = var.subnet_cidr

  # PostgreSQL config (passed through)
  postgres_version = var.postgres_version
  postgres_db_name = var.postgres_db_name
  postgres_db_user = var.postgres_db_user
  machine_type     = var.machine_type
  region           = var.region

  # --- ORGANIZATIONAL DEFAULTS (hardcoded) ---
  assign_external_ip   = true
  allow_ssh_from_cidrs = []
  enable_monitoring    = false
  enable_cloud_nat     = false

  # --- FIREWALL: allow from caller-specified CIDRs ---
  allow_postgres_from_cidrs = var.allowed_source_cidrs

  # VPC connector settings (legacy compatibility; leave empty for direct VPC egress)
  vpc_connector_cidr          = var.vpc_connector_cidr
  vpc_connector_min_instances = 2
  vpc_connector_max_instances = 10
}
