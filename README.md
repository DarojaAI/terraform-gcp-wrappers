# terraform-gcp-wrappers

Shared, opinionated Terraform wrapper modules for DarojaAI GCP infrastructure.

## Modules

| Module | Description | Consumers |
|---|---|---|
| [`postgres-stack`](modules/postgres-stack/) | PostgreSQL VM + firewall + backups | `dev-nexus`, `rag-research-tool` |

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
