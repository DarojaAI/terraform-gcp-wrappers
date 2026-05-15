# postgres-stack

Opinionated Terraform wrapper module for deploying PostgreSQL on GCP Compute Engine with DarojaAI organizational defaults.

## What it wraps

- [`gcp-postgres-terraform`](https://github.com/DarojaAI/gcp-postgres-terraform) pinned to `v4.1.0`

## Organizational defaults (non-configurable)

| Setting | Value | Rationale |
|---|---|---|
| `assign_external_ip` | `true` | GitHub Actions runner access |
| `allow_ssh_from_cidrs` | `[]` | SSH via IAP tunnel only |
| `enable_monitoring` | `false` | Avoids IAM permission errors in CI/CD |
| `enable_cloud_nat` | `false` | NAT managed by VPC module |

## Usage

```hcl
module "postgres" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/postgres-stack?ref=v1.0.0"

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

  postgres_version = "15"
  postgres_db_name = "app_database"
  postgres_db_user = "app_user"
  machine_type     = "e2-micro"
  region           = "us-central1"

  allowed_source_cidrs = [module.vpc_egress.subnet_cidr]
  vpc_connector_cidr   = ""   # direct VPC egress; no connector
}
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `project_id` | `string` | — | GCP project ID |
| `postgres_db_password` | `string` | — | PostgreSQL password (sensitive) |
| `instance_name` | `string` | — | VM instance name |
| `repo_prefix` | `string` | — | Resource naming prefix |
| `environment` | `string` | — | Deployment environment |
| `vpc_name` | `string` | — | VPC network name |
| `subnet_name` | `string` | — | Subnet name |
| `network_id` | `string` | — | VPC network id/self_link |
| `subnet_id` | `string` | — | Subnet id/self_link |
| `subnet_cidr` | `string` | — | Subnet CIDR range |
| `postgres_version` | `string` | `"15"` | PostgreSQL major version |
| `postgres_db_name` | `string` | `"app_database"` | Application DB name |
| `postgres_db_user` | `string` | `"app_user"` | Application DB user |
| `machine_type` | `string` | `"e2-micro"` | Compute Engine machine type |
| `region` | `string` | `"us-central1"` | GCP region |
| `allowed_source_cidrs` | `list(string)` | `[]` | CIDRs allowed to reach PostgreSQL |
| `vpc_connector_cidr` | `string` | `""` | `/28` for connector; empty = direct egress |

## Outputs

| Name | Description |
|---|---|
| `internal_ip` | Internal IP of the PostgreSQL VM |
| `connection_string_internal` | Internal connection string (sensitive) |
| `instance_name` | Compute Engine instance name |
| `backup_bucket_name` | GCS backup bucket name |

## Examples

- [`examples/dev-nexus/`](../examples/dev-nexus/)
- [`examples/rag-research-tool/`](../examples/rag-research-tool/)
