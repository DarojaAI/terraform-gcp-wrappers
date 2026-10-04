# terraform-gcp-wrappers

Shared, opinionated Terraform wrapper modules for DarojaAI GCP infrastructure.

## Purpose

This repo is a catalog of small, composable Terraform modules that wrap Google Cloud
provider resources (and, where useful, other DarojaAI module repos such as
`gcp-postgres-terraform`) with DarojaAI organizational defaults: consistent labeling,
environment-aware naming, and VPC-only security posture. Consumer repos pin a specific
module + git tag and override only what differs.

## Modules

| Module | What it creates/wraps | Consumers |
|---|---|---|
| [`postgres-stack`](modules/postgres-stack/) | PostgreSQL VM + firewall + backups (wraps `gcp-postgres-terraform` v4.2.0) | `dev-nexus`, `rag-research-tool` |
| [`postgres-platform`](modules/postgres-platform/) | VPC-only PostgreSQL with full passthrough + monitoring + NAT (wraps `gcp-postgres-terraform` v4.5.0) | migration target from `postgres-stack` |
| [`artifact-registry`](modules/artifact-registry/) | Google Artifact Registry repository (default DOCKER) | — |
| [`cloudbuild-trigger`](modules/cloudbuild-trigger/) | GitHub-sourced Cloud Build trigger | — |
| [`monitoring-health-check`](modules/monitoring-health-check/) | Uptime check + alert policy for a public endpoint | — |
| [`secret-manager-secret`](modules/secret-manager-secret/) | Google Secret Manager secret | — |
| [`service-account`](modules/service-account/) | Google service account | — |

Each module ships its own README with inputs/outputs and a usage example.

## Usage

```hcl
module "postgres" {
  source = "git::https://github.com/DarojaAI/terraform-gcp-wrappers.git//modules/postgres-stack?ref=v1.0.0"
  # ... see module README for inputs
}
```

## Versioning

Tags follow SemVer. Pin to a tag in `source` URLs; do not use `main` in production.

## License

MIT — see [LICENSE](LICENSE)
