# postgres-platform

Organizational Terraform wrapper module for deploying PostgreSQL on GCP Compute Engine with **VPC-only defaults** and full passthrough of all underlying `gcp-postgres-terraform` variables.

## What it wraps

- [`gcp-postgres-terraform`](https://github.com/DarojaAI/gcp-postgres-terraform) pinned to `v4.2.1`

## Differences from `postgres-stack`

| Feature | `postgres-stack` | `postgres-platform` |
|---------|-----------------|---------------------|
| `assign_external_ip` | Hardcoded `true` | Configurable, default `false` |
| `init_sql` | **Not passed through** | **Fully exposed** |
| `enable_cloud_nat` | Hardcoded `false` | Configurable, default `true` |
| `enable_monitoring` | Hardcoded `false` | Configurable, default `true` |
| Inner module name | `postgres` | `postgres` (state addresses unchanged) |

## Migration from `postgres-stack`

State addresses remain identical (`module.postgres.module.postgres.*`) because the inner module name is still `postgres`. No `terraform state mv` required.

```hcl
# Before (postgres-stack)
module "postgres" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/postgres-stack?ref=v1.0.0"
  # init_sql not available
}

# After (postgres-platform)
module "postgres" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/postgres-platform?ref=v2.0.0"

  init_sql = templatefile("${path.module}/init.sql.tpl", {
    schema_name = "myapp_public"
    db_name     = "myapp_database"
    db_user     = "myapp_user"
  })
}
```

## Usage

```hcl
module "postgres" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/postgres-platform?ref=v2.0.0"

  project_id           = var.project_id
  postgres_db_password = var.postgres_db_password
  instance_name        = "myproject-prod-pg"
  repo_prefix          = "myproject"
  environment          = "prod"

  vpc_name    = module.vpc_egress.vpc_name
  subnet_name = module.vpc_egress.subnet_name
  network_id  = module.vpc_egress.vpc_id
  subnet_id   = module.vpc_egress.subnet_id
  subnet_cidr = module.vpc_egress.subnet_cidr

  postgres_version = "16"
  postgres_db_name = "app_database"
  postgres_db_user = "app_user"
  machine_type     = "e2-micro"
  region           = "us-central1"

  # VPC-only defaults (override if needed)
  assign_external_ip = false
  enable_cloud_nat   = true

  # Schema initialization at VM boot time
  init_sql = templatefile("${path.module}/init.sql.tpl", {
    schema_name = "myapp_public"
    db_name     = "app_database"
    db_user     = "app_user"
  })

  allowed_source_cidrs = [module.vpc_egress.subnet_cidr]
  vpc_connector_cidr   = ""   # direct VPC egress; no connector
}
```

## Inputs

### Required

| Name | Type | Description |
|------|------|-------------|
| `project_id` | `string` | GCP project ID |
| `postgres_db_password` | `string` | PostgreSQL password (sensitive) |
| `instance_name` | `string` | VM instance name |
| `repo_prefix` | `string` | Resource naming prefix |
| `environment` | `string` | Deployment environment |
| `vpc_name` | `string` | VPC network name |
| `subnet_name` | `string` | Subnet name |
| `network_id` | `string` | VPC network id/self_link |
| `subnet_id` | `string` | Subnet id/self_link |
| `subnet_cidr` | `string` | Subnet CIDR range |

### Optional

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `postgres_version` | `string` | `"15"` | PostgreSQL major version |
| `postgres_db_name` | `string` | `"app_database"` | Application DB name |
| `postgres_db_user` | `string` | `"app_user"` | Application DB user |
| `machine_type` | `string` | `"e2-micro"` | Compute Engine machine type |
| `region` | `string` | `"us-central1"` | GCP region |
| `zone` | `string` | `"us-central1-b"` | GCP zone |
| `disk_size_gb` | `number` | `30` | Persistent disk size in GB |
| `disk_type` | `string` | `"pd-balanced"` | Disk type |
| `assign_external_ip` | `bool` | `false` | Assign public IP (default false for VPC-only) |
| `allow_ssh_from_cidrs` | `list(string)` | `[]` | CIDRs allowed to SSH |
| `allowed_source_cidrs` | `list(string)` | `[]` | CIDRs allowed to reach PostgreSQL |
| `vpc_connector_cidr` | `string` | `""` | /28 for connector; empty = direct egress |
| `enable_backups` | `bool` | `true` | Enable daily backups to GCS |
| `backup_retention_days` | `number` | `30` | Days to retain backups |
| `backup_schedule` | `string` | `"0 2 * * *"` | Cron schedule for backups |
| `snapshot_retention_days` | `number` | `30` | Days to retain disk snapshots |
| `enable_monitoring` | `bool` | `true` | Enable Cloud Monitoring |
| `disk_usage_alert_threshold` | `number` | `80` | Disk usage alert threshold % |
| `alert_notification_channels` | `list(string)` | `[]` | Alert notification channel IDs |
| `max_connections` | `number` | `100` | Max concurrent connections |
| `shared_buffers` | `string` | `"256MB"` | PostgreSQL shared_buffers |
| `work_mem` | `string` | `"4MB"` | PostgreSQL work_mem |
| `maintenance_work_mem` | `string` | `"64MB"` | PostgreSQL maintenance_work_mem |
| `init_sql` | `string` | `""` | SQL to run after PostgreSQL install |
| `pgvector_enabled` | `bool` | `true` | Enable pgvector extension |
| `enable_cloud_nat` | `bool` | `true` | Enable Cloud NAT (required for no-external-IP) |
| `preemptible` | `bool` | `false` | Use preemptible VM |
| `github_actions_backup_reader_sa` | `string` | `""` | SA with backup bucket read access |
| `nat_project_id` | `string` | `""` | Project containing Cloud NAT router |
| `allow_github_actions_ingress` | `bool` | `false` | Allow GitHub Actions runners to connect |
| `enable_oslogin` | `bool` | `true` | Enable OS Login |
| `labels` | `map(string)` | `{}` | Labels for all resources |

## Outputs

| Name | Description |
|------|-------------|
| `internal_ip` | Internal IP of the PostgreSQL VM |
| `connection_string_internal` | Internal connection string (sensitive) |
| `instance_name` | Compute Engine instance name |
| `backup_bucket_name` | GCS backup bucket name |
| `secret_names` | Secret Manager secret names |
| `external_ip` | External IP (if assign_external_ip = true) |
| `connection_string_external` | External connection string (sensitive) |

## Examples

- [`examples/dev-nexus/`](../examples/dev-nexus/)
- [`examples/rag-research-tool/`](../examples/rag-research-tool/)
